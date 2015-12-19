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

local function read(handle, n, endian)
  if n == nil or n == 1 then
    local a, b = handle:read(2):byte(1, 2)
    if endian == ">" then
      return a * 0x100 + b
    else
      return b * 0x100 + a
    end
  else
    local a, b, c, d = handle:read(4):byte(1, 4)
    local u
    local v
    if endian == ">" then
      u = a * 0x100 + b
      v = c * 0x100 + d
    else
      u = b * 0x100 + a
      v = d * 0x100 + c
    end
    if n == 2 then
      return u, v
    else
      return u, v, read(handle, n - 2, endian)
    end
  end
end

return {
  read = read;
}
