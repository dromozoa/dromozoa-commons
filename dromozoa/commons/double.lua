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

local function word(v, endian)
  local a = 0
  local b = 0
  if -math.huge < v and v < math.huge then
    if v == 0 then
      if ("%g"):format(v) == "-0" then
        a = 0x80000000
      end
    else
      if v < 0 then
        a = 0x80000000
        v = -v
      end
      local m, e = math.frexp(v)
      if e < -1021 then
        b = math.ldexp(m, e + 1022) * 0x100000
      else
        a = a + (e + 1022) * 0x100000
        b = (m * 2 - 1) * 0x100000
      end
    end
  else
    a = 0x7ff00000
    if v ~= math.huge then
      a = a + 0x80000000
      if v ~= -math.huge then
        b = 0x80000
      end
    end
  end
  local c = b % 1
  if endian == ">" then
    return a + b - c, c * 0x100000000
  else
    return c * 0x100000000, a + b - c
  end
end

if _VERSION >= "Lua 5.3" then
  return {
    word = function (v, endian)
      local a, b = (">I4I4"):unpack((">d"):pack(v))
      if endian == ">" then
        return a, b
      else
        return b, a
      end
    end;
  }
else
  return {
    word = word;
  }
end
