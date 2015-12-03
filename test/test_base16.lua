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

local base16 = require "dromozoa.commons.base16"

local function test(this, that)
  local code = base16.encode(this)
  assert(code == that)
  assert(base16.decode(code) == this)
  assert(base16.decode(code:lower()) == this)
end

test("", "")
test("f", "66")
test("fo", "666F")
test("foo", "666F6F")
test("foob", "666F6F62")
test("fooba", "666F6F6261")
test("foobar", "666F6F626172")
