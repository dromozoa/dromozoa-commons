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
local word_block = require "dromozoa.commons.word_block"

local function as_word(s)
  local a, b, c, d = s:byte(1, 4)
  return ((a * 256 + b) * 256 + c) * 256 + d
end

local b = word_block(2)
local s = "foobarbazqux"
assert(b:update(s, 1, 4) == 5)
assert(not b:full())
assert(b:update(s, 5, 12) == 9)
assert(b:full())
assert(b[1] == as_word("foob"))
assert(b[2] == as_word("arba"))
assert(b:update(s, 9, 12) == 13)
assert(not b:full())
assert(b[1] == as_word("zqux"))
assert(b:update("0123", 1, 4) == 5)
assert(b:full())
assert(b[1] == as_word("zqux"))
assert(b[2] == as_word("0123"))

assert(b:update("1", 1, 1) == 2)
-- print("ij1", b.i, b.j)
assert(b:update("23", 1, 2) == 3)
-- print("ij23", b.i, b.j)
assert(b:update("456", 1, 3) == 4)
-- print("ij456", b.i, b.j)
assert(b:update("7890", 1, 4) == 3)
-- print("ij7890", b.i, b.j)
-- print(i)
assert(b[1] == as_word("1234"))
assert(b[2] == as_word("5678"))

local b = word_block(2)
assert(b:update("12", 1, 2) == 3)
assert(not b:full())
assert(b:update("3", 1, 1) == 2)
assert(not b:full())
assert(b:update("45", 1, 2) == 3)
assert(not b:full())
assert(b:update("678", 1, 3) == 4)
assert(b:full())
assert(b[1] == as_word("1234"))
assert(b[2] == as_word("5678"))
assert(b:update("1234567890", 2, 10) == 10)
assert(b[1] == as_word("2345"))
assert(b[2] == as_word("6789"))
assert(b:full())

assert(b:update("abc", 1, 3))
assert(b.i == 0)
assert(b[1] == as_word("2345"))
assert(b[2] == as_word("6789"))
assert(b:flush() == 1)
assert(b.i == 1)
assert(b[1] == as_word("abc\0"))
assert(b[2] == 0)
b:reset()
assert(b[1] == 0)
assert(b[2] == 0)
