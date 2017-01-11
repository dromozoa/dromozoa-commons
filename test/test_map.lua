-- Copyright (C) 2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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
local json = require "dromozoa.commons.json"
local map = require "dromozoa.commons.map"
local pairs = require "dromozoa.commons.pairs"
local sequence = require "dromozoa.commons.sequence"

local m = map()
m.foo = 17
m.bar = 23
m.baz = 37
m.qux = 42
m.foo = 0.5
m.qux = nil

assert(m.foo == 0.5)
assert(m.bar == 23)
assert(m.baz == 37)
assert(m.qux == nil)

local data = sequence()
for k, v in m:each() do
  data:push(k, v)
end
assert(equal(data, { "bar", 23, "baz", 37, "foo", 0.5 }))

assert(json.encode(m) == [[{"bar":23,"baz":37,"foo":0.5}]])
