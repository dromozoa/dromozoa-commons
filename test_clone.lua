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

local this = {
  foo = { 17, 23, 37 };
  bar = "qux";
  baz = { { { { 42 } } } };
}

local count = 0
setmetatable(this, {
  __call = function ()
    count = count + 1
  end;
})

local that = clone(this)

this.foo, this.bar, this.baz = this.bar, this.baz, this.foo

assert(that.foo[1] == 17)
assert(that.foo[2] == 23)
assert(that.foo[3] == 37)
assert(that.bar == "qux")
assert(that.baz[1][1][1][1] == 42)

this()
that()
assert(count == 2)
