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

local clear = require "dromozoa.commons.clear"
local empty = require "dromozoa.commons.empty"
local equal = require "dromozoa.commons.equal"

local data = { "foo", "bar", "baz", qux = 42 }
local p = tostring(data)
assert(not empty(data))
assert(data[1] == "foo")
assert(data.qux == 42)
clear(data)
assert(p == tostring(data))
assert(empty(data))
assert(data[1] == nil)
assert(data.qux == nil)
