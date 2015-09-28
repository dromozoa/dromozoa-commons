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
local hash_table = require "dromozoa.commons.hash_table"
local pairs = require "dromozoa.commons.pairs"

local function test(a, b)
  local data = {}
  local m = 0
  local n = 0
  for k, v in pairs(a) do
    m = m + 1
  end
  for k, v in pairs(b) do
    n = n + 1
    assert(v == a[k])
  end
  assert(m == n)
end

local t = hash_table()
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

test(t, {
  foo = 17;
  bar = 23;
  baz = 37;
  qux = 42;
  [{}] = 69;
  [{1}] = 105;
  [{1,2}] = 666;
  [1] = "foo";
  [2] = "bar";
  [3] = "baz";
  [4] = "qux";
})
assert(#t == 4)

t.bar = nil
t[{1}] = nil

test(t, {
  foo = 17;
  baz = 37;
  qux = 42;
  [{}] = 69;
  [{1,2}] = 666;
  [1] = "foo";
  [2] = "bar";
  [3] = "baz";
  [4] = "qux";
})
assert(#t == 4)

t.qux = false
t[{1,2}] = false
t[4] = false

test(t, {
  foo = 17;
  baz = 37;
  qux = false;
  [{}] = 69;
  [{1,2}] = false;
  [1] = "foo";
  [2] = "bar";
  [3] = "baz";
  [4] = false;
})
assert(#t == 4)

assert(t.foo == 17)
assert(t[{}] == 69)
assert(t[1] == "foo")

local t2 = clone(t)
assert(equal(t, t2))
test(t2, {
  foo = 17;
  baz = 37;
  qux = false;
  [{}] = 69;
  [{1,2}] = false;
  [1] = "foo";
  [2] = "bar";
  [3] = "baz";
  [4] = false;
})
assert(#t2 == 4)

assert(table.remove(t) == false)

test(t, {
  foo = 17;
  baz = 37;
  qux = false;
  [{}] = 69;
  [{1,2}] = false;
  [1] = "foo";
  [2] = "bar";
  [3] = "baz";
})
assert(#t == 3)

local t = hash_table()
t.foo = 17
t.bar = 23
assert(equal(t, { foo = 17, bar = 23 }))
assert(equal({ foo = 17, bar = 23 }, t))
