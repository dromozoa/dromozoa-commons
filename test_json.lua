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

local linked_hash_table = require "dromozoa.commons.linked_hash_table"
local sequence = require "dromozoa.commons.sequence"
local json = require "dromozoa.commons.json"

assert(json.quote("foo\"\\/\b\f\n\r\tbar\0baz") == [["foo\"\\\/\b\f\n\r\tbar\u0000baz"]])

local t = linked_hash_table()
t.foo = sequence():push(17, 23, 37, 42)
t.bar = false
t.baz = "qux"
assert(json.encode(t) == [[{"foo":[17,23,37,42],"bar":false,"baz":"qux"}]])
