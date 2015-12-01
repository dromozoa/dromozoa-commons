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

local utf8 = require "dromozoa.commons.utf8"

assert(utf8.char() == "")
assert(utf8.char(0x00, 0x20, 0x66, 0x6F, 0x6F, 0x7F) == "\0 foo\127")
-- print(pcall(utf8.char, nil))
-- print(pcall(utf8.char, -1))
-- print(pcall(utf8.char, 0, 0x110000))
assert(not pcall(utf8.char, nil))
assert(not pcall(utf8.char, -1))
assert(not pcall(utf8.char, 0, 0x110000))

assert(utf8.char(0x0041, 0x2262, 0x0391, 0x002E) == string.char(0x41, 0xE2, 0x89, 0xA2, 0xCE, 0x91, 0x2E))
assert(utf8.char(0xD55C, 0xAD6D, 0xC5B4) == string.char(0xED, 0x95, 0x9C, 0xEA, 0xB5, 0xAD, 0xEC, 0x96, 0xB4))
assert(utf8.char(0x65E5, 0x672C, 0x8A9E) == string.char(0xE6, 0x97, 0xA5, 0xE6, 0x9C, 0xAC, 0xE8, 0xAA, 0x9E))
assert(utf8.char(0xFEFF, 0x233B4) == string.char(0xEF, 0xBB, 0xBF, 0xF0, 0xA3, 0x8E, 0xB4))
