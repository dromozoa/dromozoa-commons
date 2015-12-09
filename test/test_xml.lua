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

local x = [[
<comment lang="en" date="2012-09-11">
I <em>love</em> &#xB5;<!-- MICRO SIGN -->XML!<br/>
It's so clean &amp; simple.</comment>
]]

local j = [[
[ "comment",
  { "date": "2012-09-11", "lang": "en" },
  [ "\nI ",
    [ "em", {}, ["love"] ],
    " \u00B5XML!",
    [ "br", {}, [] ],
    "\nIt's so clean & simple."
  ]
]
]]
assert(equal(xml.decode(x), json.decode(j)))



