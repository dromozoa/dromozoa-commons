-- Copyright (C) 2015,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local sequence = require "dromozoa.commons.sequence"
local string_matcher = require "dromozoa.commons.string_matcher"

local m = string_matcher("foo\tbar\tbaz\n")

assert(m:match("(.)(.)(.)"))
assert(#m == 3)
assert(m[1] == "f")
assert(m[2] == "o")
assert(m[3] == "o")
assert(m[4] == nil)
assert(m.i == 1)
assert(m.j == 3)

assert(m:match("\t"))
assert(#m == 0)
assert(m[1] == nil)
assert(m.i == 4)
assert(m.j == 4)

assert(m:lookahead("(b)"))
assert(#m == 1)
assert(m[1] == "b")
assert(m[2] == nil)
assert(m.i == 5)
assert(m.j == 5)

assert(not m:match("foo"))
assert(#m == 0)
assert(m[1] == nil)
assert(m.i == nil)
assert(m.j == nil)

assert(m:match("bar"))
assert(m:match("(%s)"))
assert(#m == 1)
assert(m[1] == "\t")
assert(m[2] == nil)
assert(m.i == 8)
assert(m.j == 8)
assert(not m:eof())

assert(m:match("(.+)"))
assert(#m == 1)
assert(m[1] == "baz\n")
assert(m[2] == nil)
assert(m.i == 9)
assert(m.j == 12)
assert(m:eof())

local m = string_matcher("\tfoo\tbar\t")
local done = false
local data = sequence()
repeat
  assert(m:match("([^\t]*)"))
  data:push(m[1])
  done = not m:match("\t")
until done
assert(data, { "", "foo", "bar", "" })

local m = string_matcher("___((()))___", 4)
assert(m:match("%b()"))
assert(m.i == 4)
assert(m.j == 9)
assert(m.position == 10)
assert(not m:eof())

assert(string_matcher(""):eof())
assert(not string_matcher("foo"):eof())
