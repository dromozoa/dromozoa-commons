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

local function word(v)
  local a = v % 0x100000000
  local b = (v - a) / 0x100000000
  return a, b
end

if _VERSION >= "Lua 5.3" then
  return {
    word = function (v)
      local a, b = ("<I4I4"):unpack(("<I8"):pack(v))
      return a, b
    end;
  }
else
  return {
    word = word;
  }
end
