-- Copyright (C) 2016 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local basename = require "dromozoa.commons.basename"

assert(basename("/usr/lib") == "lib")
assert(basename("/usr/") == "usr")
assert(basename("/") == "/")
assert(basename("///") == "/")
assert(basename("//usr//lib//") == "lib")

assert(basename("foo") == "foo")
assert(basename("foo/") == "foo")
assert(basename(".") == ".")
assert(basename("..") == "..")
