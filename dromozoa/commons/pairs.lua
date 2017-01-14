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

local getmetafield = require "dromozoa.commons.getmetafield"
local lua_version_num = require "dromozoa.commons.lua_version_num"

if lua_version_num >= 502 then
  return pairs
else
  return function (self)
    local t = type(self)
    if t ~= "table" then
      error("bad argument #1 to 'pairs' (table expected, got " .. t .. ")")
    end
    local metafield = getmetafield(self, "__pairs")
    if metafield == nil then
      return next, self, nil
    else
      return metafield(self)
    end
  end
end
