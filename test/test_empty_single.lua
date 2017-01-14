-- Copyright (C) 2015,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local empty = require "dromozoa.commons.empty"
local hash_table = require "dromozoa.commons.hash_table"
local linked_hash_table = require "dromozoa.commons.linked_hash_table"
local multimap = require "dromozoa.commons.multimap"
local queue = require "dromozoa.commons.queue"
local single = require "dromozoa.commons.single"

local t = linked_hash_table()
assert(empty(""))
assert(empty({}))
assert(empty(hash_table()))
assert(empty(linked_hash_table()))
assert(empty(queue()))

assert(not single(""))
assert(not single({}))
assert(not single(hash_table()))
assert(not single(linked_hash_table()))
assert(not single(queue()))

assert(not empty("f"))
assert(not empty("foo"))
assert(not empty({ 42 }))
assert(not empty({ foo = 42 }))
local t = hash_table()
t.foo = 42
assert(not empty(t))
local t = linked_hash_table()
t.foo = 42
assert(not empty(t))
assert(not empty(queue():push("foo")))

assert(single("f"))
assert(not single("foo"))
assert(single({ 42 }))
assert(single({ foo = 42 }))
local t = hash_table()
t.foo = 42
assert(single(t))
t.bar = 69
assert(not single(t))
local t = linked_hash_table()
t.foo = 42
assert(single(t))
t.bar = 69
assert(not single(t))
assert(single(queue():push("foo")))

local t = multimap()
assert(empty(t))
assert(not single(t))
t:insert("foo", 42)
assert(not empty(t))
assert(single(t))
t:insert("bar", 69)
assert(not empty(t))
assert(not single(t))
