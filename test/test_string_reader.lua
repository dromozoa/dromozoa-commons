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
local sequence = require "dromozoa.commons.sequence"
local string_reader = require "dromozoa.commons.string_reader"
local write_file = require "dromozoa.commons.write_file"

local tmpname = os.tmpname()
local destruct = setmetatable({}, {
  __gc = function ()
    -- io.write("__gc remove ", tmpname, "\n")
    os.remove(tmpname)
  end;
})

local function test_impl(data, fn, ...)
  assert(write_file(tmpname, data))
  local f = assert(io.open(tmpname))
  local s = string_reader(data)
  fn(f, s, ...)
  f:close()
end

local function test(data, fn, ...)
  test_impl(data, fn, ...)
  test_impl(data:upper(), fn, ...)
  test_impl(data:lower(), fn, ...)
end

local function test_read(f, s, ...)
  while true do
    local a, b = f:read(...)
    local c, d = s:read(...)
    -- print(a, b, c, d)
    -- print(type(a), type(b), type(c), type(d))
    assert(a == c)
    assert(b == d)
    if a == nil then
      break
    end
  end
end

test("", test_read)
test("foo\nbar\nbaz", test_read)
test("foo\nbar\nbaz\n", test_read)

test("", test_read, "*l")
test("foo\nbar\nbaz", test_read, "*l")
test("foo\nbar\nbaz\n", test_read, "*l")

if _VERSION >= "Lua 5.2" then
  test("", test_read, "*L")
  test("foo\nbar\nbaz", test_read, "*L")
  test("foo\nbar\nbaz\n", test_read, "*L")
end

test("", test_read, 8)
test("foo\nbar\nbaz", test_read, 8)
test("foo\nbar\nbaz\n", test_read, 8)

test("", test_read, 0, 1)
test("foo\nbar\nbaz", test_read, 0, 1)
test("foo\nbar\nbaz\n", test_read, 0, 1)

test("", test_read, 4, "*a")
test("foo\nbar\nbaz", test_read, 4, "*a")
test("foo\nbar\nbaz\n", test_read, 4, "*a")

test("1 1e3 1e+3 1e-3", test_read, "*n")
test("1. 1.e3 1.e+3 1.e-3", test_read, "*n")
test(".25 .25e3 .25e+3 .25e-3", test_read, "*n")
test("1.25 1.25e3 1.25e+3 1.25e-3", test_read, "*n")

test("+1 -1", test_read, "*n")
test("+.25 -.25", test_read, "*n")
test("0000 0123", test_read, "*n")

test("0x80 0x80p3 0x80p+3 0x80p-3", test_read, "*n")
test("0x80. 0x80.p3 0x80.p+3 0x80.p-3", test_read, "*n")
test("0x.c 0x.cp3 0x.cp+3 0x.cp-3", test_read, "*n")
test("0x80.c 0x80.cp3 0x80.cp+3 0x80.cp-3", test_read, "*n")

test("+0x80 -0x80", test_read, "*n")
test("+0x.c -0x.c", test_read, "*n")
test("0xfeedface", test_read, "*n")

test("+", test_read, "*n")
test("-", test_read, "*n")
if _VERSION >= "Lua 5.3" then
  test("0x", test_read, "*n")
  test("0x.", test_read, "*n")
end
assert(string_reader("0x"):read("*n") == nil)

test("foo\nbar\nbaz\n", function (f, s)
  -- print(pcall(f.read, f, nil))
  -- print(pcall(s.read, s, nil))
  -- print(pcall(f.read, f, "*l", nil))
  -- print(pcall(s.read, s, "*l", nil))
  assert(not pcall(f.read, f, nil))
  assert(not pcall(s.read, s, nil))
  assert(not pcall(f.read, f, "*l", nil))
  assert(not pcall(s.read, s, "*l", nil))
end)

local function test_lines(f, s, ...)
  local a = sequence()
  local b = sequence()
  for i, j in f:lines(...) do
    -- print("f", i, j)
    a:push(i, j)
  end
  for i, j in s:lines(...) do
    -- print("s", i, j)
    b:push(i, j)
  end
  assert(equal(a, b))
end

test("", test_lines)
test("foo\nbar\nbaz", test_lines)
test("foo\nbar\nbaz\n", test_lines)

if _VERSION >= "Lua 5.2" then
  test("", test_lines, "*l")
  test("foo\nbar\nbaz", test_lines, "*l")
  test("foo\nbar\nbaz\n", test_lines, "*l")

  test("", test_lines, "*L")
  test("foo\nbar\nbaz", test_lines, "*L")
  test("foo\nbar\nbaz\n", test_lines, "*L")

  test("", test_lines, "*l", "*l")
  test("foo\nbar\nbaz", test_lines, "*l", "*l")
  test("foo\nbar\nbaz\n", test_lines, "*l", "*l")

  test("", test_lines, 8)
  test("foo\nbar\nbaz", test_lines, 8)
  test("foo\nbar\nbaz\n", test_lines, 8)
end

test("foo\nbar\nbaz\n", function (f, s)
  assert(f:read() == s:read())
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("cur", -1) == s:seek("cur", -1))
  -- print(f:seek())

  assert(f:read() == s:read())
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("cur", 2) == s:seek("cur", 2))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:read() == s:read())
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("cur", 5) == s:seek("cur", 5))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("cur", -100) == s:seek("cur", -100))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("set") == s:seek("set"))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("set", 2) == s:seek("set", 2))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("set", -1) == s:seek("set", -1))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("end") == s:seek("end"))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:read() == s:read())
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("end", -2) == s:seek("end", -2))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(f:seek("end", 2) == s:seek("end", 2))
  -- print(f:seek())
  assert(f:seek() == s:seek())

  assert(not pcall(f.seek, f, "foo'bar"))
  assert(not pcall(s.seek, s, "foo'bar"))
end)
