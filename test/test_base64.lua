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

local base64 = require "dromozoa.commons.base64"

local function test(this, that)
  local code = base64.encode(this)
  assert(code == that)
  -- print(this, that)
  -- print(base64.decode(code))
  assert(base64.decode(code) == this)
end

test("", "")
test("f", "Zg==")
test("fo", "Zm8=")
test("foo", "Zm9v")
test("foob", "Zm9vYg==")
test("fooba", "Zm9vYmE=")
test("foobar", "Zm9vYmFy")
test("ABCDEFG", "QUJDREVGRw==")

assert(not base64.decode("Zm9v===="))
assert(not base64.decode("Zm9vZ==="))
assert(not base64.decode("Zg=/"))
assert(not base64.decode("Zg==Zg=="))
assert(not base64.decode("Zm8=Zg=="))
assert(not base64.decode("Zh=="))
assert(not base64.decode("Zm9="))

assert(base64.encode_url("") == "")
assert(base64.encode_url("f") == "Zg")
assert(base64.encode_url("fo") == "Zm8")
assert(base64.encode_url("foo") == "Zm9v")
assert(base64.encode_url("\251") == "-w")
assert(base64.encode_url("\252") == "_A")
