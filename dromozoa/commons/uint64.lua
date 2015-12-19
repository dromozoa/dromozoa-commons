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

local lua_version_num = require "dromozoa.commons.lua_version_num"

local function word(v, endian)
  local b = v % 0x100000000
  local a = (v - b) / 0x100000000
  if endian == ">" then
    return a, b
  else
    return b, a
  end
end

if lua_version_num >= 503 then
  return {
    word = function (v, endian)
      if endian == ">" then
        local a, b = (">I4I4"):unpack((">I8"):pack(v))
        return a, b
      else
        local a, b = ("<I4I4"):unpack(("<I8"):pack(v))
        return a, b
      end
    end;
  }
else
  return {
    word = word;
  }
end
