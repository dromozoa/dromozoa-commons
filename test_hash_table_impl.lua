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

local hash_table_impl = require "dromozoa.commons.hash_table_impl"

local metatable = {
  __index = hash_table_impl;
}

local t = setmetatable(hash_table_impl.new(), metatable)

assert(t:insert({}) == nil)
assert(t:insert({}) == true)
assert(t:remove({}) == true)
assert(t:remove({}) == nil)

assert(t:empty())

assert(t:set({}, 17) == nil)
assert(t:set({1}, 23) == nil)
assert(t:set({1,2}, 37) == nil)
assert(t:set({1,2,3}, 42) == nil)
assert(t:set({1,2,3,4}, 69) == nil)
assert(t:set({1,2,3,4,5}, 105) == nil)
assert(t:set({1,2,3,4,5,6}, 666) == nil)

assert(t:get({}) == 17)
assert(t:get({1}) == 23)
assert(t:get({1,2}) == 37)
assert(t:get({1,2,3}) == 42)
assert(t:get({1,2,3,4}) == 69)
assert(t:get({1,2,3,4,5}) == 105)
assert(t:get({1,2,3,4,5,6}) == 666)

local m = 0
local n = 0
for k, v in t:each() do
  m = m + v
  n = n + 1
end
assert(m == 17 + 23 + 37 + 42 + 69 + 105 + 666)
assert(n == 7)

assert(t:set({}, nil) == 17)
assert(t:set({1}, nil) == 23)

assert(t:get({}) == nil)
assert(t:get({1}) == nil)
assert(t:get({1,2}) == 37)
assert(t:get({1,2,3}) == 42)
assert(t:get({1,2,3,4}) == 69)
assert(t:get({1,2,3,4,5}) == 105)
assert(t:get({1,2,3,4,5,6}) == 666)

assert(t:set({1,2,3,4,5}, nil) == 105)
assert(t:set({1,2,3,4,5,6}, nil) == 666)

assert(t:get({}) == nil)
assert(t:get({1}) == nil)
assert(t:get({1,2}) == 37)
assert(t:get({1,2,3}) == 42)
assert(t:get({1,2,3,4}) == 69)
assert(t:get({1,2,3,4,5}) == nil)
assert(t:get({1,2,3,4,5,6}) == nil)

assert(t:set({1,2,3,4}, nil) == 69)

assert(t:get({}) == nil)
assert(t:get({1}) == nil)
assert(t:get({1,2}) == 37)
assert(t:get({1,2,3}) == 42)
assert(t:get({1,2,3,4}) == nil)
assert(t:get({1,2,3,4,5}) == nil)
assert(t:get({1,2,3,4,5,6}) == nil)

assert(t:set({1,2}, nil) == 37)
assert(t:set({1,2,3}, nil) == 42)

assert(t:get({}) == nil)
assert(t:get({1}) == nil)
assert(t:get({1,2}) == nil)
assert(t:get({1,2,3}) == nil)
assert(t:get({1,2,3,4}) == nil)
assert(t:get({1,2,3,4,5}) == nil)
assert(t:get({1,2,3,4,5,6}) == nil)

assert(t:empty())
