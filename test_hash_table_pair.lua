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
local hash_table_pair = require "dromozoa.commons.hash_table_pair"

local p = hash_table_pair()
assert(p:empty())

local h1 = p:insert("foo", 17)
local h2 = p:insert("bar", 23)
local h3 = p:insert("baz", 37)
assert(h1 == 1)
assert(h2 == 2)
assert(h3 == 3)
assert(not p:empty())

local k, v = p:find(h1)
assert(k == "foo")
assert(v == 17)

assert(p:get(h1) == 17)
assert(p:get(h2) == 23)
assert(p:get(h3) == 37)

assert(p:set(h1, 42) == 17)
assert(p:get(h1) == 42)

local m = 0
local n = 0
for k, v in p:each() do
  m = m + v
  n = n + 1
end
assert(m == 42 + 23 + 37)
assert(n == 3)

local p2 = clone(p)
assert(equal(p, p2))
assert(not p:empty())
assert(p:get(h1) == 42)
assert(p:get(h2) == 23)
assert(p:get(h3) == 37)

assert(p:remove(h3) == 37)
assert(p:remove(h1) == 42)
assert(p:remove(h2) == 23)
assert(p:empty())
