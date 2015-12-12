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
local word_block = require "dromozoa.commons.word_block"

local add = uint32.add
local band = uint32.band
local bxor = uint32.bxor
local bnot = uint32.bnot
local rotl = uint32.rotl
local char = uint32.char

local K1 = 0x5a827999
local K2 = 0x6ed9eba1
local K3 = 0x8f1bbcdc
local K4 = 0xca62c1d6

local function Ch(x, y, z)
  return bxor(band(x, y), band(bnot(x), z))
end

local function Parity(x, y, z)
  return bxor(x, y, z)
end

local function Maj(x, y, z)
  return bxor(band(x, y), band(x, z), band(y, z))
end

local function update(self)
  local M = self.M
  local W = self.W
  local H = self.H

  for t = 1, 16 do
    W[t] = M[t]
  end
  for t = 17, 80 do
    W[t] = rotl(bxor(W[t - 3], W[t - 8], W[t - 14], W[t - 16]), 1)
  end

  local H1 = H[1]
  local H2 = H[2]
  local H3 = H[3]
  local H4 = H[4]
  local H5 = H[5]

  local a, b, c, d, e = H1, H2, H3, H4, H5

  for t = 1, 20 do
    local T = add(rotl(a, 5), Ch(b, c, d), e, K1, W[t])
    e = d
    d = c
    c = rotl(b, 30)
    b = a
    a = T
  end

  for t = 21, 40 do
    local T = add(rotl(a, 5), Parity(b, c, d), e, K2, W[t])
    e = d
    d = c
    c = rotl(b, 30)
    b = a
    a = T
  end

  for t = 41, 60 do
    local T = add(rotl(a, 5), Maj(b, c, d), e, K3, W[t])
    e = d
    d = c
    c = rotl(b, 30)
    b = a
    a = T
  end

  for t = 61, 80 do
    local T = add(rotl(a, 5), Parity(b, c, d), e, K4, W[t])
    e = d
    d = c
    c = rotl(b, 30)
    b = a
    a = T
  end

  H[1] = add(a, H1)
  H[2] = add(b, H2)
  H[3] = add(c, H3)
  H[4] = add(d, H4)
  H[5] = add(e, H5)
end

local class = {}

function class.new()
  return class.reset({
    M = word_block(16);
    W = sequence();
    H = sequence();
    L = 0;
  })
end

function class:reset()
  local H = self.H
  H[1] = 0x67452301
  H[2] = 0xefcdab89
  H[3] = 0x98badcfe
  H[4] = 0x10325476
  H[5] = 0xc3d2e1f0
  return self
end

function class:update(s, i, j)
  local s = tostring(s)
  local min, max = translate_range(#s, i, j)
  self.L = self.L + max - min + 1
  local M = self.M
  while min <= max do
    min = M:update(s, min, max)
    if M:full() then
      update(self)
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
  update(self)
  return self
end

function class:finalize(encode)
  local M = self.M
  M:update("\128", 1, 1)
  if M:flush() > 14 then
    update(self)
    M:reset()
  end
  M[15], M[16] = uint64.word(self.L * 8, ">")
  update(self)
  local H = self.H
  if encode == "hex" then
    return ("%08x%08x%08x%08x%08x"):format(H[1], H[2], H[3], H[4], H[5])
  elseif encode == "bin" then
    local bin = sequence()
    for i = 1, 5 do
      bin:push(char(H[i], ">"))
    end
    return bin:concat()
  else
    return H
  end
end

function class.bin(message)
  return class():update(message):finalize("bin")
end

function class.hex(message)
  return class():update(message):finalize("hex")
end

function class.hmac(K, text, encode)
  if #K > 64 then
    K = class.bin(K)
  end
  local h = class():update_hmac(K, 0x36363636):update(text):finalize("bin")
  return class():update_hmac(K, 0x5c5c5c5c):update(h):finalize(encode)
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
