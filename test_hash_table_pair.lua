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

local json = require "dromozoa.json"
local pair = require "dromozoa.commons.hash_table.pair"

local metatable = {
  __index = pair;
}

local p = setmetatable(pair.new(), metatable)
print(json.encode(p))
assert(p:empty())

p:push_back("foo", 17)
assert(not p:empty())
p:push_back("bar", 23)
p:push_back("baz", 37)
print(json.encode(p))

local k, v = p:pop_back()
print(json.encode(p))
assert(k == "baz")
assert(v == 37)

local k, v = p:pop_front()
print(json.encode(p))
assert(k == "foo")
assert(v == 17)

local k, v = p:pop_front()
print(json.encode(p))
assert(k == "bar")
assert(v == 23)

local k, v = p:pop_front()
assert(k == nil)
assert(v == nil)

for k, v in p:each() do
  print(k, v)
end


