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

local block = require "dromozoa.commons.block"
local equal = require "dromozoa.commons.equal"

local b = block(8)
local s = "foobarbazqux"
local i = b:update(s, 1, 4)
assert(i == 5)
assert(not b:is_full())
local i = b:update(s, i)
assert(i == 9)
assert(b:is_full())
assert(equal({ b:byte(1, 4) }, { ("foob"):byte(1, 4) }))
assert(b:byte(5) == ("a"):byte())
assert(b:byte(6) == ("r"):byte())
assert(b:byte(7) == ("b"):byte())
assert(b:byte(8) == ("a"):byte())
local i = b:update(s, i)
assert(i == 13)
assert(not b:is_full())
assert(equal({ b:byte(1, 4) }, { ("zqux"):byte(1, 4) }))
local i = b:update("0123")
assert(i == 5)
assert(b:is_full())
assert(equal({ b:byte(1, 8) }, { ("zqux0123"):byte(1, 8) }))
