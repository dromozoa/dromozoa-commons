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
local hash_table = require "dromozoa.commons.hash_table"
local pairs = require "dromozoa.commons.pairs"

local function test(a, b)
  local data = {}
  local n = 0
  for k, v in pairs(a) do
    n = n + 1
  end
  for k, v in pairs(b) do
    n = n - 1
    assert(equal(v, a[k]))
  end
  assert(n == 0)
end

local t = hash_table()
assert(t:empty())

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
assert(not t:empty())

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
