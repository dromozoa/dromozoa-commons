-- Copyright (C) 2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local murmur_hash3 = require "dromozoa.commons.murmur_hash3"
local pairs = require "dromozoa.commons.pairs"
local uint32 = require "dromozoa.commons.uint32"

local function hash(key, h)
  if h == nil then
    h = 0
  end
  local t = type(key)
  if t == "number" then
    h = murmur_hash3.uint32(1, h)
    h = murmur_hash3.double(key, h)
  elseif t == "string" then
    h = murmur_hash3.uint32(2, h)
    h = murmur_hash3.string(key, h)
  elseif t == "boolean" then
    h = murmur_hash3.uint32(3, h)
    if key then
      h = murmur_hash3.uint32(1, h)
    else
      h = murmur_hash3.uint32(0, h)
    end
  elseif t == "table" then
    h = murmur_hash3.uint32(4, h)
    local H = 0
    for k, v in pairs(key) do
      H = uint32.add(H, hash(v, hash(k, h)))
    end
    h = murmur_hash3.uint32(H, h)
  end
  return h
end

return hash
