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
local json = require "dromozoa.commons.json"
local xml = require "dromozoa.commons.xml"

local a, b = xml.escape("<>&\"'")
assert(a == "&lt;&gt;&amp;&quot;&apos;")
assert(b == nil)
assert(xml.escape(42) == "42")
assert(xml.escape("[foo]", "%W") == "&#x5b;foo&#x5d;")

local X = [[
<comment lang="en" date="2012-09-11">
I <em>love</em> &#xB5;<!-- MICRO SIGN -->XML!<br/>
It's so
clean &amp; simple.</comment>
]]

local J = [====[
[ "comment",
  { "date": "2012-09-11", "lang": "en" },
  [ "\nI ",
    [ "em", {}, ["love"] ],
    " \u00B5XML!",
    [ "br", {}, [] ],
    "\nIt's so\nclean & simple."
  ]
]
]====]

assert(equal(xml.decode(X), json.decode(J)))
assert(equal(xml.decode(X:gsub("\n", "\r\n")), json.decode(J)))
assert(equal(xml.decode(X:gsub("\n", "\r")), json.decode(J)))

assert(equal(xml.decode([[
<location><city>New York</city><country>US</country></location>
]]), json.decode([====[
["location", {}, [["city", {}, ["New York"]], ["country", {}, ["US"]]]]
]====])))

assert(not pcall(xml.decode, [[
<location><city>New York</city><country>US</country><location>
]]))

assert(equal(xml.decode([[
<page-break/>
]]), json.decode([====[
["page-break", {}, []]
]====])))

assert(equal(xml.decode([[
<location city="New York" country="US"/>
]]), json.decode([====[
["location", {"city": "New York", "country": "US"}, []]
]====])))

assert(equal(xml.decode([[
<root><!-- declarations for <head> & <body> --></root>
]]), json.decode([====[
["root", {}, []]
]====])))

assert(equal(xml.decode([[
<p>&#x3C;&#x3bb;</p>
]]), json.decode([====[
["p", {}, ["\u003c\u03bb"]]
]====])))

assert(equal(xml.decode([[
<p>&amp;&lt;&gt;&quot;&apos;</p>
]]), json.decode([====[
["p", {}, ["&<>\"'"]]
]====])))

assert(equal(xml.decode([[
<p>&amp;&lt;&gt;&quot;&apos;</p>
]]), json.decode([====[
["p", {}, ["&<>\"'"]]
]====])))

local X = [[
<doc att="hello
world"/>
]]

local J = [====[
["doc", {"att": "hello\nworld"}, []]
]====]

assert(equal(xml.decode(X), json.decode(J)))
assert(equal(xml.decode(X:gsub("\n", "\r\n")), json.decode(J)))
assert(equal(xml.decode(X:gsub("\n", "\r")), json.decode(J)))

assert(equal(xml.decode([[
<?xml version="1.0"?>
<foo/>
]]), json.decode([====[
["foo", {}, []]
]====])))

assert(equal(xml.decode([[
<?xml version="1.0" charset="UTF-8"?>
<!-- comment -->
<!DOCTYPE html>
<html><head></head><body><p>foo</p></body></html>
]]), json.decode([====[
[ "html", {}, [
  [ "head", {}, [] ],
  [ "body", {}, [
    [ "p", {}, [ "foo" ] ]
  ]]
]]
]====])))

assert(equal(xml.decode([[
<foo xmlns="https://example.com/"/>
]]), json.decode([====[
[ "foo", { "xmlns": "https://example.com/" }, [] ]
]====])))

assert(not pcall(xml.decode, [[<foo><]]))
assert(not pcall(xml.decode, [[<foo><bar]]))
assert(not pcall(xml.decode, [[<foo><bar>]]))
assert(not pcall(xml.decode, [[<foo></]]))
assert(not pcall(xml.decode, [[<foo></bar]]))
assert(not pcall(xml.decode, [[<foo></bar>]]))
assert(not pcall(xml.decode, [[<foo/><!--]]))
assert(not pcall(xml.decode, [[<foo/><!-- -->&]]))

assert(equal(xml.decode([[
 <foo bar = " baz'qux " >
 <foo bar = ' baz"qux ' />
 </foo >
]]), json.decode([====[
[ "foo", { "bar": " baz'qux " }, [ "\n ", [ "foo", { "bar": " baz\"qux " }, [] ], "\n " ] ]
]====])))
