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

local equal = require "dromozoa.commons.equal"
local sequence = require "dromozoa.commons.sequence"

local s = sequence()
s:push()
s:push(17)
s:push(23, 37)
assert(equal(s, { 17, 23, 37 }))

local s = sequence()
s:push(17)
s:push(23)
s:push(37)
assert(#s == 3)
assert(s:top() == 37)
assert(s:pop() == 37)
assert(s:pop() == 23)
assert(s:pop() == 17)
assert(#s == 0)
assert(s:top() == nil)
assert(s:pop() == nil)

local s = sequence()
s:copy({})
s:copy({ 17 })
s:copy({ 23, 37 })
assert(equal(s, { 17, 23, 37 }))

local s = sequence()
s:copy({ 17, 23, 37, 42 }, 2)
assert(equal(s, { 23, 37, 42 }))

local s = sequence()
s:copy({ 17, 23, 37, 42 }, 2, 3)
assert(equal(s, { 23, 37 }))

local s = sequence()
s:copy({ 17, 23, 37, 42 }, -3)
assert(equal(s, { 23, 37, 42 }))

local s = sequence()
s:copy({ 17, 23, 37, 42 }, -3, -2)
assert(equal(s, { 23, 37 }))

local m = 0
local n = 0
for v in sequence():push(17, 23, 37, 42):each() do
  m = m + v
  n = n + 1
end
assert(m == 17 + 23 + 37 + 42)
assert(n == 4)

local s = sequence():push("foo", "bar", "baz", "qux")
assert(s:concat() == "foobarbazqux")
assert(s:concat(",") == "foo,bar,baz,qux")
