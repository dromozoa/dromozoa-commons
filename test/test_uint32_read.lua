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
local uint32 = require "dromozoa.commons.uint32"

local handle = string_reader(string.char(0xfe, 0xed, 0xfa, 0xce, 0xde, 0xad, 0xbe, 0xef))

local function test(n, endian, that)
  handle:seek("set", 0)
  local result = { uint32.read(handle, n, endian) }
  assert(equal(result, that))
end

test(1, ">", { 0xfeedface })
test(2, ">", { 0xfeedface, 0xdeadbeef })

test(1, "<", { 0xcefaedfe })
test(2, "<", { 0xcefaedfe, 0xefbeadde })
