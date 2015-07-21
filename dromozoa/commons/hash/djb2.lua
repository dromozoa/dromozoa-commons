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

local double = require "dromozoa.commons.double"
local uint32 = require "dromozoa.commons.uint32"
local uint64 = require "dromozoa.commons.uint64"

local function update(hash, a, b, c, d)
  hash = hash * 1089 + a * 33 + b
  hash = hash % 0x100000000
  hash = hash * 1089 + c * 33 + d
  hash = hash % 0x100000000
  return hash
end

return {
  uint32 = function (key, hash)
    hash = update(hash, uint32.byte(key))
    return hash
  end;

  uint64 = function (key, hash)
    local a, b = uint64.word(key)
    hash = update(hash, uint32.byte(a))
    hash = update(hash, uint32.byte(b))
    return hash
  end;

  double = function (key, hash)
    local a, b = double.word(key)
    hash = update(hash, uint32.byte(a))
    hash = update(hash, uint32.byte(b))
    return hash
  end;

  string = function (key, hash)
    local n = #key
    local m = n - n % 4
    for i = 4, m, 4 do
      hash = update(hash, string.byte(key, i - 3, i))
    end
    if m < n then
      local a, b, c = string.byte(key, m + 1, n)
      if c then
        hash = hash * 35937 + a * 1089 + b * 33 + c
      elseif b then
        hash = hash * 1089 + a * 33 + b
      else
        hash = hash * 33 + a
      end
      hash = hash % 0x100000000
    end
    return hash
  end;
}
