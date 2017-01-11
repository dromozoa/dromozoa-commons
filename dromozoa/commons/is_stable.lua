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

local linked_hash_table = require "dromozoa.commons.linked_hash_table"
local map = require "dromozoa.commons.map"
local multimap = require "dromozoa.commons.multimap"
local multimap_handle = require "dromozoa.commons.multimap_handle"

local stable_metatables = {
  [linked_hash_table.metatable] = true;
  [map.metatable] = true;
  [multimap.metatable] = true;
  [multimap_handle.metatable] = true;
}

return function (self)
  if type(self) == "table" then
    if stable_metatables[getmetatable(self)] then
      return true
    end
  end
end
