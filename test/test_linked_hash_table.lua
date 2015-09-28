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
local linked_hash_table = require "dromozoa.commons.linked_hash_table"
local pairs = require "dromozoa.commons.pairs"

local function test(a, b)
  local data = {}
  for k, v in pairs(a) do
    data[#data + 1] = { k, v }
  end
  assert(equal(data, b))
end

local t = linked_hash_table()
assert(t[nil] == nil)

t.foo = 17
t.bar = 23
t.baz = 37
t.qux = 42
t[{}] = 69
t[{1}] = 105
t[{1,2}] = 666
t[1] = "foo"
t[2] = "bar"
t[3] = "baz"
t[4] = "qux"

assert(t:identity("foo") == 1)
assert(t:identity("bar") == 2)
assert(t:identity("baz") == 3)
assert(t:identity("qux") == 4)
assert(t:identity({}) == 5)
assert(t:identity({1}) == 6)
assert(t:identity({1,2}) == 7)
assert(t:identity(1) == 8)
assert(t:identity(2) == 9)
assert(t:identity(3) == 10)
assert(t:identity(4) == 11)
assert(t:identity(5) == nil)

local k, v = t:find(4)
assert(k == "qux")
assert(v == 42)

test(t, {
  { "foo", 17 };
  { "bar", 23 };
  { "baz", 37 };
  { "qux", 42 };
  { {}, 69 };
  { {1}, 105 };
  { {1,2}, 666 };
  { 1, "foo" };
  { 2, "bar" };
  { 3, "baz" };
  { 4, "qux" };
})

t.bar = nil
t[{1}] = nil

test(t, {
  { "foo", 17 };
  { "baz", 37 };
  { "qux", 42 };
  { {}, 69 };
  { {1,2}, 666 };
  { 1, "foo" };
  { 2, "bar" };
  { 3, "baz" };
  { 4, "qux" };
})

t.qux = false
t[{1,2}] = false
t[4] = false

test(t, {
  { "foo", 17 };
  { "baz", 37 };
  { "qux", false };
  { {}, 69 };
  { {1,2}, false };
  { 1, "foo" };
  { 2, "bar" };
  { 3, "baz" };
  { 4, false };
})

assert(t.foo == 17)
assert(t[{}] == 69)
assert(t[1] == "foo")

local t2 = clone(t)
assert(equal(t, t2))
test(t, {
  { "foo", 17 };
  { "baz", 37 };
  { "qux", false };
  { {}, 69 };
  { {1,2}, false };
  { 1, "foo" };
  { 2, "bar" };
  { 3, "baz" };
  { 4, false };
})

local t = linked_hash_table()
t.foo = 17
t.bar = 23
assert(equal(t, { foo = 17, bar = 23 }))
assert(equal({ foo = 17, bar = 23 }, t))

local n = 0
for k, v, i in t:each() do
  n = n + 1
  assert(i == n)
end

for k, v, i in pairs(t) do
  assert(i == nil)
end
