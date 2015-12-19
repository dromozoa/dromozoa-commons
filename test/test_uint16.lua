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
local string_reader = require "dromozoa.commons.string_reader"
local uint16 = require "dromozoa.commons.uint16"

local handle = string_reader(string.char(0xfe, 0xed, 0xfa, 0xce, 0xde, 0xad, 0xbe, 0xef))

local function test(n, endian, that)
  handle:seek("set", 0)
  local result = { uint16.read(handle, n, endian) }
  assert(equal(result, that))
end

test(1, ">", { 0xfeed })
test(2, ">", { 0xfeed, 0xface })
test(3, ">", { 0xfeed, 0xface, 0xdead })
test(4, ">", { 0xfeed, 0xface, 0xdead, 0xbeef })

test(1, "<", { 0xedfe })
test(2, "<", { 0xedfe, 0xcefa })
test(3, "<", { 0xedfe, 0xcefa, 0xadde })
test(4, "<", { 0xedfe, 0xcefa, 0xadde, 0xefbe })

assert(equal({ uint16.byte(0xfeed, ">") }, { 0xfe, 0xed }))

assert(uint16.char(0xfeed, ">") == string.char(0xfe, 0xed))
assert(uint16.char(0xfeed, "<") == string.char(0xed, 0xfe))
