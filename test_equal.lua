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

local a = { 1, 2, 3 }
local b = { 1, 2, 3 }
assert(a ~= b)
assert(equal(a, b))

local a = { foo = a }
local b = { foo = b }
assert(a ~= b)
assert(equal(a, b))

local metatable = {
  __call = function ()
    io.write("called\n")
  end;
}
setmetatable(a, metatable)
assert(not equal(a, b))
setmetatable(b, metatable)
assert(equal(a, b))

a()
b()

assert(not equal({ foo = 17, bar = 23 }, { foo = 17, bar = 23, baz = 37 }))
assert(not equal({ foo = 17, bar = 23, baz = 37 }, { foo = 17, bar = 23 }))
