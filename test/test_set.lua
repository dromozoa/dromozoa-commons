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

local clone = require "dromozoa.commons.clone"
local equal = require "dromozoa.commons.equal"
local set = require "dromozoa.commons.set"

assert(set.includes({ foo = 17, bar = 23 }, { bar = 37 }))
assert(not set.includes({ foo = 17, bar = 23 }, { bar = 37, baz = 42 }))

local a = { foo = 17; bar = 23 }
local b = { bar = 37; baz = 42 }
assert(set.difference(a, b) == 1)
assert(equal(a, { foo = 17 }))

local a = { foo = 17; bar = 23 }
local b = { bar = 37; baz = 42 }
assert(set.intersection(a, b) == 1)
assert(equal(a, { bar = 23 }))

local a = { foo = 17; bar = 23 }
local b = { bar = 37; baz = 42 }
assert(set.symmetric_difference(a, b) == 2)
assert(equal(a, { foo = 17; baz = 42 }))

local a = { foo = 17; bar = 23 }
local b = { bar = 37; baz = 42 }
assert(set.union(a, b) == 1)
assert(equal(a, { foo = 17; bar = 23; baz = 42 }))

local p = { foo = 17; bar = 23 }
local q = { bar = 37; baz = 42 }
local a = clone(p)
local b = clone(p)
set.union(a, q)
set.intersection(b, q)
set.difference(a, b)
assert(equal(a, { foo = 17, baz = 42 }))

local a = set()
a.foo = 17
a.bar = 23
local b = set()
b.bar = 37
b.baz = 42
assert(equal(a:set_union(b):set_difference(b), { foo = 17 }))
