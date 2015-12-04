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

local function as_word(s)
  local a, b, c, d = s:byte(1, 4)
  return ((a * 256 + b) * 256 + c) * 256 + d
end

local b = block(2)
local s = "foobarbazqux"
local i = b:update(s, 1, 4)
assert(i == 5)
assert(not b:is_full())
local i = b:update(s, i)
assert(i == 9)
assert(b:is_full())
assert(b[1] == as_word("foob"))
assert(b[2] == as_word("arba"))
local i = b:update(s, i)
assert(i == 13)
assert(not b:is_full())
assert(b[1] == as_word("zqux"))
local i = b:update("0123")
assert(i == 5)
assert(b:is_full())
assert(b[1] == as_word("zqux"))
assert(b[2] == as_word("0123"))

-- print("---1")
local i = b:update("1")
-- print("ij1", b.i, b.j)
assert(i == 2)
-- print("---23")
local i = b:update("23")
-- print("ij23", b.i, b.j)
assert(i == 3)
-- print("---456")
local i = b:update("456")
-- print("ij456", b.i, b.j)
assert(i == 4)
-- print("---7890")
local i = b:update("7890")
-- print("ij7890", b.i, b.j)
-- print(i)
assert(i == 3)
assert(b[1] == as_word("1234"))
assert(b[2] == as_word("5678"))
assert(b.size == 24)

local b = block(2)
assert(b:update("12") == 3)
assert(not b:is_full())
assert(b:update("3") == 2)
assert(not b:is_full())
assert(b:update("45") == 3)
assert(not b:is_full())
assert(b:update("678") == 4)
assert(b:is_full())
assert(b[1] == as_word("1234"))
assert(b[2] == as_word("5678"))
assert(b:update("1234567890", 2) == 10)
assert(b[1] == as_word("2345"))
assert(b[2] == as_word("6789"))
assert(b:is_full())
assert(b.size == 16)
