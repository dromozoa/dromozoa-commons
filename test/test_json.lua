-- Copyright (C) 2015,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local empty = require "dromozoa.commons.empty"
local equal = require "dromozoa.commons.equal"
local linked_hash_table = require "dromozoa.commons.linked_hash_table"
local sequence = require "dromozoa.commons.sequence"
local json = require "dromozoa.commons.json"

local function test(this, that)
  local value = json.decode(this)
  local code = json.encode(value)
  if that == nil then
    assert(equal(code, this))
  else
    assert(equal(code, that))
  end
end

assert(json.quote("foo\"\\/\b\f\n\r\tbar\0baz") == [["foo\"\\\/\b\f\n\r\tbar\u0000baz"]])
assert(json.quote(42) == [["42"]])
assert(json.quote(string.char(0x1B)) == [["\u001B"]])

local t = linked_hash_table()
t.foo = sequence():push(17, 23, 37, 42)
t.bar = false
t.baz = "qux"
local s = [[{"foo":[17,23,37,42],"bar":false,"baz":"qux"}]]
assert(json.encode(t) == s)

test(s)
test([[0]])
test([[-1.25]])
test([[-1.25e3]], [[-1250]])
test([[-1e3]], [[-1000]])
test([["foo\"\\\/\b\f\n\r\tbar\u0000baz"]])
test([[""]])
test([["\u65E5\u672C\u8A9E"]], [["日本語"]])
test([["\uD84C\uDFB4"]], "\"" .. string.char(0xF0, 0xA3, 0x8E, 0xB4) .. "\"")

assert(json.decode("null") == json.null)
assert(json.decode(" 42 ") == 42)

-- print(pcall(json.decode, [[ { 42 } ]]))
-- print(pcall(json.decode, [[ { "foo" } ]]))
-- print(pcall(json.decode, [[ { "foo": 17 23 } ]]))
-- print(pcall(json.decode, [[ [ 17 23 ] ]]))
-- print(pcall(json.decode, [[ "\uXXXX" ]]))
-- print(pcall(json.decode, [[ 0000 ]]))
-- print(pcall(json.decode, [[ { ]]))
-- print(pcall(json.decode, [[    ]]))

assert(not pcall(json.decode, [[ { 42 } ]]))
assert(not pcall(json.decode, [[ { "foo" } ]]))
assert(not pcall(json.decode, [[ { "foo": 17 23 } ]]))
assert(not pcall(json.decode, [[ [ 17 23 ] ]]))
assert(not pcall(json.decode, [[ "\uXXXX" ]]))
assert(not pcall(json.decode, [[ 0000 ]]))
assert(not pcall(json.decode, [[ { ]]))
assert(not pcall(json.decode, [[    ]]))

local value, matcher = json.parse("0000")
assert(value == 0)
assert(not matcher:eof())
assert(matcher.position == 2)

assert(empty(json.decode("[]")))
assert(empty(json.decode("{}")))
assert(equal(json.decode([[ [ 17 , 23 ] ]]), { 17, 23 }))
assert(equal(json.decode([[ { "foo" : 17 , "bar" : 23 } ]]), { foo = 17, bar = 23 }))

local t = {
  array = sequence();
  table = {};
  one = { 42 };
}
assert(json.encode(t, { stable = true }) == [[{"array":[],"one":[42],"table":{}}]])

local t = {
  foo = { 17, 23, 37, 42 };
  ["foo bar"] = 0.25;
  [true] = "foo";
  bar = { 42 };
  baz = { baz = false };
  qux = {};
  [1] = { { sequence() } };
  [2] = { foo = { bar = { baz = "qux" } } };
  [function () end] = "ignore";
}

local result1 = json.encode(t)
local result2 = json.encode(t, { pretty = true })
local result3 = json.encode(t, { stable = true })
local result4 = json.encode(t, { pretty = true, stable = true })
-- print(result1)
-- print(result2)
-- print(result3)
-- print(result4)
assert(equal(json.decode(result1), json.decode(result2)))
assert(equal(json.decode(result1), json.decode(result3)))
assert(equal(json.decode(result1), json.decode(result4)))
assert(result3 == [=[{"1":[[[]]],"2":{"foo":{"bar":{"baz":"qux"}}},"bar":[42],"baz":{"baz":false},"foo bar":0.25,"foo":[17,23,37,42],"qux":{},"true":"foo"}]=])

local t = linked_hash_table()
t.foo = linked_hash_table()
t.foo.bar = 17;
t.foo.baz = 23;
t.foo.qux = 42;
local result = json.encode(t, { pretty = true, stable = true })
-- print(result)
assert(result == [[
{
  "foo": {
    "bar": 17,
    "baz": 23,
    "qux": 42
  }
}]])

local result = json.encode({ { { { { 17 } } } }, { { { { 23, 37, 42 } } } } }, { pretty = true })
-- print(result)
assert(result == [=[
[
  [
    [
      [
        [
          17
        ]
      ]
    ]
  ],
  [
    [
      [
        [
          23,
          37,
          42
        ]
      ]
    ]
  ]
]]=])
