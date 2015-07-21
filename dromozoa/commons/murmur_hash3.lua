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

local uint32 = require "dromozoa.commons.uint32"

local add = uint32.add
local mul = uint32.mul
local bxor = uint32.bxor
local shl = uint32.shl
local shr = uint32.shr
local rotl = uint32.rotl

local function update1(hash, k)
  k = mul(k, 0xCC9E2D51)
  k = rotl(k, 15)
  k = mul(k, 0x1B873593)
  hash = bxor(hash, k)
  return hash
end

local function update2(hash)
  hash = rotl(hash, 13)
  hash = mul(hash, 5)
  hash = add(hash, 0xE6546B64)
  return hash
end

local function finalize(hash, n)
  hash = bxor(hash, n)
  hash = bxor(hash, shr(hash, 16))
  hash = mul(hash, 0x85EBCA6B)
  hash = bxor(hash, shr(hash, 13))
  hash = mul(hash, 0xC2B2AE35)
  hash = bxor(hash, shr(hash, 16))
  return hash
end

return {
  string = function(key, hash)
    local hash = hash
    local n = #key
    local m = n - n % 4
    for i = 4, m, 4 do
      local a, b, c, d = string.byte(key, i - 3, i)
      hash = update1(hash, a + b * 0x100 + c * 0x10000 + d * 0x1000000)
      hash = update2(hash)
    end
    if m < n then
      local a, b, c = string.byte(key, m + 1, n)
      if c then
        hash = update1(hash, a + b * 0x100 + c * 0x10000)
      elseif b then
        hash = update1(hash, a + b * 0x100)
      else
        hash = update1(hash, a)
      end
    end
    return finalize(hash, n)
  end;
}
