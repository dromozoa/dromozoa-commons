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

local sequence = require "dromozoa.commons.sequence"
local xml = require "dromozoa.commons.xml"
local xml_selector = require "dromozoa.commons.xml_selector"

local e1 = xml.decode("<E/>")
local e2 = xml.decode("<F foo='bar'/>")
local e3 = xml.decode("<E foo='bar'/>")
local e4 = xml.decode("<E foo='42'/>")
local e5 = xml.decode("<E foo='42 bar'/>")
local e6 = xml.decode("<E foo='bar 69'/>")
local e7 = xml.decode("<E foo='42 bar 69'/>")
local e8 = xml.decode("<E foo='en'/>")
local e9 = xml.decode("<E foo='en-US'/>")
local e10 = xml.decode("<E class=''/>")
local e11 = xml.decode("<E class='error'/>")
local e12 = xml.decode("<E class='error warning'/>")
local e13 = xml.decode("<E id='42'/>")
local e14 = xml.decode("<E id='myid'/>")

assert(    xml.selector("*")              (e1, { e1 }, 1))
assert(    xml.selector("E")              (e1, { e1 }, 1))
assert(not xml.selector("E")              (e2, { e2 }, 1))
assert(not xml.selector("E[foo]")         (e1, { e1 }, 1))
assert(not xml.selector("E[foo]")         (e2, { e2 }, 1))
assert(    xml.selector("E[foo]")         (e3, { e3 }, 1))
assert(    xml.selector("E[foo=\"bar\"]") (e3, { e3 }, 1))
assert(not xml.selector("E[foo=\"bar\"]") (e4, { e4 }, 1))
assert(    xml.selector("E[foo~=\"bar\"]")(e3, { e3 }, 1))
assert(not xml.selector("E[foo~=\"bar\"]")(e4, { e4 }, 1))
assert(    xml.selector("E[foo~=\"bar\"]")(e5, { e5 }, 1))
assert(    xml.selector("E[foo~=\"bar\"]")(e6, { e6 }, 1))
assert(    xml.selector("E[foo~=\"bar\"]")(e7, { e7 }, 1))
assert(    xml.selector("E[foo^=\"bar\"]")(e3, { e3 }, 1))
assert(not xml.selector("E[foo^=\"bar\"]")(e4, { e4 }, 1))
assert(not xml.selector("E[foo^=\"bar\"]")(e5, { e5 }, 1))
assert(    xml.selector("E[foo^=\"bar\"]")(e6, { e6 }, 1))
assert(not xml.selector("E[foo^=\"bar\"]")(e7, { e7 }, 1))
assert(    xml.selector("E[foo$=\"bar\"]")(e3, { e3 }, 1))
assert(not xml.selector("E[foo$=\"bar\"]")(e4, { e4 }, 1))
assert(    xml.selector("E[foo$=\"bar\"]")(e5, { e5 }, 1))
assert(not xml.selector("E[foo$=\"bar\"]")(e6, { e6 }, 1))
assert(not xml.selector("E[foo$=\"bar\"]")(e7, { e7 }, 1))
assert(    xml.selector("E[foo*=\"bar\"]")(e3, { e3 }, 1))
assert(not xml.selector("E[foo*=\"bar\"]")(e4, { e4 }, 1))
assert(    xml.selector("E[foo*=\"bar\"]")(e5, { e5 }, 1))
assert(    xml.selector("E[foo*=\"bar\"]")(e6, { e6 }, 1))
assert(    xml.selector("E[foo*=\"bar\"]")(e7, { e7 }, 1))
assert(not xml.selector("E[foo|=\"en\"]") (e3, { e3 }, 1))
assert(not xml.selector("E[foo|=\"en\"]") (e4, { e4 }, 1))
assert(    xml.selector("E[foo|=\"en\"]") (e8, { e8 }, 1))
assert(    xml.selector("E[foo|=\"en\"]") (e9, { e9 }, 1))
assert(not xml.selector("E.warning")      (e1, { e1 }, 1))
assert(not xml.selector("E.warning")      (e3, { e3 }, 1))
assert(not xml.selector("E.warning")      (e10, { e10 }, 1))
assert(not xml.selector("E.warning")      (e11, { e11 }, 1))
assert(    xml.selector("E.warning")      (e12, { e12 }, 1))
assert(not xml.selector("*.warning")      (e1, { e1 }, 1))
assert(not xml.selector("*.warning")      (e3, { e3 }, 1))
assert(not xml.selector("*.warning")      (e10, { e10 }, 1))
assert(not xml.selector("*.warning")      (e11, { e11 }, 1))
assert(    xml.selector("*.warning")      (e12, { e12 }, 1))
assert(not xml.selector(".warning")       (e1, { e1 }, 1))
assert(not xml.selector(".warning")       (e3, { e3 }, 1))
assert(not xml.selector(".warning")       (e10, { e10 }, 1))
assert(not xml.selector(".warning")       (e11, { e11 }, 1))
assert(    xml.selector(".warning")       (e12, { e12 }, 1))
assert(not xml.selector("E#myid")         (e1, { e1 }, 1))
assert(not xml.selector("E#myid")         (e3, { e3 }, 1))
assert(not xml.selector("E#myid")         (e13, { e13 }, 1))
assert(    xml.selector("E#myid")         (e14, { e14 }, 1))
assert(not xml.selector("*#myid")         (e1, { e1 }, 1))
assert(not xml.selector("*#myid")         (e3, { e3 }, 1))
assert(not xml.selector("*#myid")         (e13, { e13 }, 1))
assert(    xml.selector("*#myid")         (e14, { e14 }, 1))
assert(not xml.selector("#myid")          (e1, { e1 }, 1))
assert(not xml.selector("#myid")          (e3, { e3 }, 1))
assert(not xml.selector("#myid")          (e13, { e13 }, 1))
assert(    xml.selector("#myid")          (e14, { e14 }, 1))
assert(not xml.selector("E F")            (e1, { e1, e1 }, 2))
assert(    xml.selector("E F")            (e2, { e1, e2 }, 2))
assert(not xml.selector("E F")            (e2, { e2, e2 }, 2))
assert(    xml.selector("E F")            (e2, { e1, e2, e2 }, 3))
assert(not xml.selector("E>F")            (e1, { e1, e1 }, 2))
assert(    xml.selector("E>F")            (e2, { e1, e2 }, 2))
assert(not xml.selector("E>F")            (e2, { e2, e2 }, 2))
assert(not xml.selector("E>F")            (e2, { e1, e2, e2 }, 3))
assert(    xml.selector("D,E")            (e1, { e1 }, 1))
assert(not xml.selector("D,E")            (e2, { e2 }, 1))
assert(    xml.selector("A,B,C,D,E")      (e1, { e1 }, 1))
assert(not xml.selector("A,B,C,D,E")      (e2, { e2 }, 1))
assert(not xml.selector(":not(E)")        (e1, { e1 }, 1))
assert(    xml.selector(":not(E)")        (e2, { e2 }, 1))

assert(not xml.selector("[foo=bar]>[foo='42']>[foo^=bar]") (e5, { e3, e4, e5 }, 3))
assert(    xml.selector("[foo=bar]>[foo='42']>[foo^=bar]") (e6, { e3, e4, e6 }, 3))
assert(not xml.selector("[foo=bar]>[foo='42']>[foo^=bar]") (e5, { e3, e3, e5 }, 3))
assert(not xml.selector("[foo=bar] [foo='42'] [foo^=bar]") (e5, { e3, e4, e5 }, 3))
assert(    xml.selector("[foo=bar] [foo='42'] [foo^=bar]") (e6, { e3, e4, e6 }, 3))
assert(not xml.selector("[foo=bar] [foo='42'] [foo^=bar]") (e5, { e3, e3, e5 }, 3))
assert(not xml.selector("[foo~='42'][foo~=bar][foo~='69']")(e5, { e5 }, 1))
assert(not xml.selector("[foo~='42'][foo~=bar][foo~='69']")(e6, { e6 }, 1))
assert(    xml.selector("[foo~='42'][foo~=bar][foo~='69']")(e7, { e7 }, 1))
