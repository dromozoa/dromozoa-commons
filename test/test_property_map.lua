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

local json = require "dromozoa.commons.json"
local property_map = require "dromozoa.commons.property_map"
local linked_hash_table = require "dromozoa.commons.linked_hash_table"

local p = property_map()
p:set_property(17, "color", "red")
p:set_property(23, "color", "green")
p:set_property(37, "color", "blue")
p:set_property(42, "answer", true)

assert(p:get_property(17, "color") == "red")
assert(p:get_property(17, "answer") == nil)
assert(p:get_property(42, "color") == nil)
assert(p:get_property(42, "answer") == true)
assert(p:get_property(69, "color") == nil)
assert(p:get_property(69, "answer") == nil)

for k, v in p:each_property(17) do
  assert(k == "color")
  assert(v == "red")
end

for k, v in p:each_property(42) do
  assert(k == "answer")
  assert(v == true)
end

local count = 0
for k, v in p:each_property(69) do
  count = count + 1
end
assert(count == 0)

assert(p:set_property(42, "color", "silver") == nil)
assert(p:set_property(42, "color", "gold") == "silver")

local m = 0
local n = 0
for handle in p:each_item("color") do
  m = m + handle
  n = n + 1
end
assert(m == 17 + 23 + 37 + 42)
assert(n == 4)

p:remove_item(42)
assert(p:get_property(42, "color") == nil)
assert(p:get_property(42, "answer") == nil)

assert(p.dataset.answer == nil)

local m = 0
local n = 0
for handle in p:each_item("color") do
  m = m + handle
  n = n + 1
end
assert(m == 17 + 23 + 37)
assert(n == 3)

assert(p:set_property(42, "answer", true) == nil)
p:clear_key("color")

assert(p:get_property(17, "color") == nil)
assert(p:get_property(17, "answer") == nil)
assert(p:get_property(42, "color") == nil)
assert(p:get_property(42, "answer") == true)

local m = 0
local n = 0
for handle in p:each_item("color") do
  m = m + handle
  n = n + 1
end
assert(m == 0)
assert(n == 0)
