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
local split = require "dromozoa.commons.split"

assert(equal(split("foo  bar \tbaz", "%s"), { "foo", "", "bar", "", "baz" }))
assert(equal(split("foo  bar \tbaz", "%s+"), { "foo", "bar", "baz" }))
assert(equal(split("foo  bar \tbaz", "(%s+)"), { "foo", "  ", "bar", " \t", "baz" }))
assert(equal(split("foo  bar \tbaz", "(%s)(%s)"), { "foo", " ", " ", "bar", " ", "\t", "baz" }))
assert(equal(split("foo", ""), { "f", "o", "o" }))
assert(equal(split(" foo ", ""), { " ", "f", "o", "o", " " }))

local data = {}
for v in split("foo,bar,baz", ","):each() do
  data[v] = true
end
assert(equal(data, { foo = true, bar = true, baz = true }))

assert(equal(split("", "%s+"), {""}))
assert(equal(split(" ", "%s+"), {""}))
