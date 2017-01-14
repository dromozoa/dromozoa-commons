-- Copyright (C) 2015,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local double = require "dromozoa.commons.double"
local translate_range = require "dromozoa.commons.translate_range"
local uint32 = require "dromozoa.commons.uint32"
local uint64 = require "dromozoa.commons.uint64"

local add = uint32.add
local mul = uint32.mul
local bxor = uint32.bxor
local shr = uint32.shr
local rotl = uint32.rotl

local function update1(hash, key)
  key = mul(key, 0xcc9e2d51)
  key = rotl(key, 15)
  key = mul(key, 0x1b873593)
  hash = bxor(hash, key)
  return hash
end

local function update2(hash)
  hash = rotl(hash, 13)
  hash = mul(hash, 5)
  hash = add(hash, 0xe6546b64)
  return hash
end

local function finalize(hash, n)
  hash = bxor(hash, n)
  hash = bxor(hash, shr(hash, 16))
  hash = mul(hash, 0x85ebca6b)
  hash = bxor(hash, shr(hash, 13))
  hash = mul(hash, 0xc2b2ae35)
  hash = bxor(hash, shr(hash, 16))
  return hash
end

local class = {}

function class.uint32(key, hash)
  hash = update1(hash, key)
  hash = update2(hash)
  return finalize(hash, 4)
end

function class.uint64(key, hash)
  local a, b = uint64.word(key)
  hash = update1(hash, a)
  hash = update2(hash)
  hash = update1(hash, b)
  hash = update2(hash)
  return finalize(hash, 8)
end

function class.double(key, hash)
  local a, b = double.word(key)
  hash = update1(hash, a)
  hash = update2(hash)
  hash = update1(hash, b)
  hash = update2(hash)
  return finalize(hash, 8)
end

function class.string(key, hash, i, j)
  local min, max = translate_range(#key, i, j)
  for i = min + 3, max, 4 do
    local a, b, c, d = key:byte(i - 3, i)
    hash = update1(hash, a + b * 0x100 + c * 0x10000 + d * 0x1000000)
    hash = update2(hash)
  end
  local i = max + 1
  local p = i - (i - min) % 4
  if p < i then
    local a, b, c = key:byte(p, max)
    if c then
      hash = update1(hash, a + b * 0x100 + c * 0x10000)
    elseif b then
      hash = update1(hash, a + b * 0x100)
    else
      hash = update1(hash, a)
    end
  end
  return finalize(hash, i - min)
end

return class
