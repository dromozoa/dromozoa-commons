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

local sha256 = require "dromozoa.commons.sha256"
local unpack = require "dromozoa.commons.unpack"

local d = sha256()
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.M, 1, 8)))
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.M, 9, 16)))
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.H)))

d:update("abc")
print("--")
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.M, 1, 8)))
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.M, 9, 16)))
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.H)))

d:finalize()
print("--")
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.M, 1, 8)))
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.M, 9, 16)))
print(string.format("%08x %08x %08x %08x %08x %08x %08x %08x", unpack(d.H)))

print("--")
print(sha256.hex(""))
print(sha256.hex("abc"))

