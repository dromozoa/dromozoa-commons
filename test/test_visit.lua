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

local visit = require "dromozoa.commons.visit"

local visitor = {
  foo = function (_, a, b, c) return a + b + c end;
  bar = function () return 42 end;
  a = "qux";
  b = 42;
  c = true;
  d = false;
}

assert(visit(visitor, "foo", 17, 23, 37) == 17 + 23 + 37)
assert(visit(visitor, "bar", 17, 23, 37) == 42)
assert(visit(visitor, "baz", 17, 23, 37) == nil)
assert(visit(visitor, "a", 17, 23, 37) == "qux")
assert(visit(visitor, "b", 17, 23, 37) == 42)
assert(visit(visitor, "c", 17, 23, 37) == true)
assert(visit(visitor, "d", 17, 23, 37) == false)
