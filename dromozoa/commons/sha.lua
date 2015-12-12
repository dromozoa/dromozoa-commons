-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-commons.
--
-- dromozoa-commons is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-commons is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-commons.  If not, see <http://www.gnu.org/licenses/>.

local sequence = require "dromozoa.commons.sequence"
local translate_range = require "dromozoa.commons.translate_range"
local uint32 = require "dromozoa.commons.uint32"
local uint64 = require "dromozoa.commons.uint64"
local unpack = require "dromozoa.commons.unpack"

local band = uint32.band
local bxor = uint32.bxor
local bnot = uint32.bnot
local char = uint32.char

local class = {
  Parity = bxor;
}

function class.Ch(x, y, z)
  return bxor(band(x, y), band(bnot(x), z))
end

function class.Maj(x, y, z)
  return bxor(band(x, y), band(x, z), band(y, z))
end

function class:update(s, i, j)
  local s = tostring(s)
  local min, max = translate_range(#s, i, j)
  self.L = self.L + max - min + 1
  local M = self.M
  while min <= max do
    min = M:update(s, min, max)
    if M:full() then
      self:compute()
    end
  end
  return self
end

function class:update_hmac(s, pad)
  local s = tostring(s)
  self.L = self.L + 64
  local M = self.M
  M:update(s, 1, #s)
  M:flush()
  M.i = 16
  for i = 1, 16 do
    M[i] = bxor(M[i], pad)
  end
  self:compute()
  return self
end

function class:finalize(encode)
  local M = self.M
  M:update("\128", 1, 1)
  if M:flush() > 14 then
    self:compute()
    M:reset()
  end
  M[15], M[16] = uint64.word(self.L * 8, ">")
  self:compute()
  local H = self.H
  if encode == "hex" then
    return self.hex_format:format(unpack(H))
  elseif encode == "bin" then
    local bin = sequence()
    for i = 1, #H do
      bin:push(char(H[i], ">"))
    end
    return bin:concat()
  else
    return H
  end
end

function class.hmac(class, K, text, encode)
  if #K > 64 then
    K = class.bin(K)
  end
  local h = class():update_hmac(K, 0x36363636):update(text):finalize("bin")
  return class():update_hmac(K, 0x5c5c5c5c):update(h):finalize(encode)
end

return class
