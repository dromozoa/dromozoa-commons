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

local string_buffer = require "dromozoa.commons.string_buffer"
local dumper = require "dromozoa.commons.dumper"

local function make_string_buffer(skip)
  local b = string_buffer():write("foo"):write("bar"):write("baz")
  if skip ~= nil then
    b:read(skip)
  end
  return b
end

local b = make_string_buffer()

assert(b.min == 1)
assert(b.max == 3)
assert(b.i == nil)
assert(b.size == 9)
assert(not b.eof)

assert(b:read(2) == "fo")
assert(b:read(2) == "ob")
assert(b:read(2) == "ar")
assert(b:read(2) == "ba")
assert(b:read(2) == nil)
b:close()
assert(b:read(2) == "z")

assert(b.min == 1)
assert(b.max == 0)
assert(b.i == nil)
assert(b.size == 0)
assert(b.eof)

assert(make_string_buffer():read(6) == "foobar")
assert(make_string_buffer():read(7) == "foobarb")
assert(make_string_buffer():read(8) == "foobarba")
assert(make_string_buffer():read(9) == "foobarbaz")
assert(make_string_buffer():read(10) == nil)
assert(make_string_buffer():close():read(10) == "foobarbaz")

assert(make_string_buffer(1):read(5) == "oobar")
assert(make_string_buffer(1):read(6) == "oobarb")
assert(make_string_buffer(1):read(7) == "oobarba")
assert(make_string_buffer(1):read(8) == "oobarbaz")
assert(make_string_buffer(1):read(9) == nil)
assert(make_string_buffer(1):close():read(9) == "oobarbaz")

assert(make_string_buffer(3):read(3) == "bar")
assert(make_string_buffer(3):read(4) == "barb")
assert(make_string_buffer(3):read(5) == "barba")
assert(make_string_buffer(3):read(6) == "barbaz")
assert(make_string_buffer(3):read(7) == nil)
assert(make_string_buffer(3):close():read(7) == "barbaz")
