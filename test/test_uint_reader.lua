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

local apply = require "dromozoa.commons.apply"
local uint_reader = require "dromozoa.commons.uint_reader"
local string_reader = require "dromozoa.commons.string_reader"

local s = string.char(0xfe, 0xed, 0xfa, 0xce, 0xde, 0xad, 0xbe, 0xef)

local r = uint_reader(string_reader(s))
local a, b, c, d = r:read_uint8(4)
assert(a == 0xfe)
assert(b == 0xed)
assert(c == 0xfa)
assert(d == 0xce)
assert(r:read_uint8() == 0xde)
assert(r:read_uint8() == 0xad)
assert(r:read_uint8() == 0xbe)
assert(r:read_uint8() == 0xef)

local r = uint_reader(string_reader(s))
local a, b = r:read_uint16(2)
assert(a == 0xedfe)
assert(b == 0xcefa)
assert(r:read_uint16() == 0xadde)
assert(r:read_uint16() == 0xefbe)

local r = uint_reader(string_reader(s), ">")
local a, b = r:read_uint16(2)
assert(a == 0xfeed)
assert(b == 0xface)
assert(r:read_uint16() == 0xdead)
assert(r:read_uint16() == 0xbeef)

local r = uint_reader(string_reader(s), "<")
local a, b = r:read_uint32(2)
assert(a == 0xcefaedfe)
assert(b == 0xefbeadde)
r:seek("set", 0)
assert(r:read_uint32() == 0xcefaedfe)
assert(r:read_uint32() == 0xefbeadde)

local r = uint_reader(string_reader(s), ">")
local a, b = r:read_uint32(2)
assert(a == 0xfeedface)
assert(b == 0xdeadbeef)
r:seek("set", 0)
assert(r:read_uint32() == 0xfeedface)
assert(r:read_uint32() == 0xdeadbeef)

local r = uint_reader(string_reader("foo\nbar\n 42 baz"))
assert(apply(r:lines()) == "foo")
assert(r:read(4) == "bar\n")
assert(r:read("*n") == 42)
assert(r:read("*a") == " baz")
