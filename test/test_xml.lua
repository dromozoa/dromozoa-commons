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

local dumper = require "dromozoa.commons.dumper"
local equal = require "dromozoa.commons.equal"
local json = require "dromozoa.commons.json"
local xml = require "dromozoa.commons.xml"

local a, b = xml.escape("<>&\"'")
assert(a == "&lt;&gt;&amp;&quot;&apos;")
assert(b == nil)
assert(xml.escape(42) == "42")
assert(xml.escape("[foo]", "%W") == "&#x5b;foo&#x5d;")
assert(xml.escape("\t\r\n ") == "\t\r\n ")
assert(xml.escape("\0\127") == "&#x0;&#x7f;")

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

-- print(xml.encode(json.decode(J)))
-- print(xml.decode(xml.encode(json.decode(J))))
assert(equal(xml.decode(X), xml.decode(xml.encode(json.decode(J)))))
-- print(xml.encode("\0\1\2\3\4\5\6\7\8\9\10\11\12\13\14\15\16"))
assert(xml.encode("\0\1\2\3\4\5\6\7\8\9\10\11\12\13\14\15\16") == "&#x0;&#x1;&#x2;&#x3;&#x4;&#x5;&#x6;&#x7;&#x8;\t\n&#xb;&#xc;\r&#xe;&#xf;&#x10;")

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
assert(not pcall(xml.decode, "<foo>\0</foo>"))
assert(not pcall(xml.decode, "<foo bar='\0'/>"))
assert(not pcall(xml.decode, "<foo\f/>"))
assert(not pcall(xml.decode, "<foo>\f</foo>"))

assert(equal(xml.decode("<foo>\t</foo>"), { "foo", {}, { "\t" } }))
assert(equal(xml.decode("<foo bar='\t'/>"), { "foo", { bar = "\t" }, {} }))

assert(equal(xml.decode([[
 <foo bar = " baz'qux " >
 <foo bar = ' baz"qux ' />
 </foo >
]]), json.decode([====[
[ "foo", { "bar": " baz'qux " }, [ "\n ", [ "foo", { "bar": " baz\"qux " }, [] ], "\n " ] ]
]====])))

assert(tostring(xml.decode("<foo><bar baz='qux'/></foo>")[3][1]) == [[<bar baz="qux"/>]])
xml.encode({ "name", { foo = 17, bar = 23, baz = 37 }, { { "qux", {}, { 42 } } } })

local doc = xml.decode([[
<html>
  <head>
    <title>title</title>
  </head>
  <body>
    <div>
      <p>foo</p>
    </div>
    <div>
      <div>
        <p class="a">bar</p>
      </div>
    </div>
    <p class="a b">baz</p>
    <p foo="17" bar="23" baz="37">qux</p>
  </body>
</html>
]])

assert(doc:query("no-such-tag") == nil)
assert(doc:query(":not(*)") == nil)
assert(doc:query("p"):text() == "foo")
assert(doc:query("div p"):text() == "foo")
assert(doc:query("body p"):text() == "foo")
assert(doc:query("html p"):text() == "foo")
assert(doc:query("div div p"):text() == "bar")
assert(doc:query(".a"):text() == "bar")
assert(doc:query("body > p"):text() == "baz")
assert(doc:query(":not(div) > p"):text() == "baz")
assert(doc:query(".a.b"):text() == "baz")
assert(doc:query("[foo][bar]"):text() == "qux")
assert(doc:query("[foo][bar][baz]"):text() == "qux")
assert(doc:query_all("p"):text() == "foobarbazqux")
assert(doc:query_all("p.a"):text() == "barbaz")
assert(doc:query_all("html > *"):query_all("* > title, * > p"):query(".b"):text() == "baz")
