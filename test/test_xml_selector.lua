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
local xml_selector = require "dromozoa.commons.xml_selector_parser"

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

assert(    xml_selector("*")              :apply()(e1, { e1 }, 1))
assert(    xml_selector("E")              :apply()(e1, { e1 }, 1))
assert(not xml_selector("E")              :apply()(e2, { e2 }, 1))
assert(not xml_selector("E[foo]")         :apply()(e1, { e1 }, 1))
assert(not xml_selector("E[foo]")         :apply()(e2, { e2 }, 1))
assert(    xml_selector("E[foo]")         :apply()(e3, { e3 }, 1))
assert(    xml_selector("E[foo=\"bar\"]") :apply()(e3, { e3 }, 1))
assert(not xml_selector("E[foo=\"bar\"]") :apply()(e4, { e4 }, 1))
assert(    xml_selector("E[foo~=\"bar\"]"):apply()(e3, { e3 }, 1))
assert(not xml_selector("E[foo~=\"bar\"]"):apply()(e4, { e4 }, 1))
assert(    xml_selector("E[foo~=\"bar\"]"):apply()(e5, { e5 }, 1))
assert(    xml_selector("E[foo~=\"bar\"]"):apply()(e6, { e6 }, 1))
assert(    xml_selector("E[foo~=\"bar\"]"):apply()(e7, { e7 }, 1))
assert(    xml_selector("E[foo^=\"bar\"]"):apply()(e3, { e3 }, 1))
assert(not xml_selector("E[foo^=\"bar\"]"):apply()(e4, { e4 }, 1))
assert(not xml_selector("E[foo^=\"bar\"]"):apply()(e5, { e5 }, 1))
assert(    xml_selector("E[foo^=\"bar\"]"):apply()(e6, { e6 }, 1))
assert(not xml_selector("E[foo^=\"bar\"]"):apply()(e7, { e7 }, 1))
assert(    xml_selector("E[foo$=\"bar\"]"):apply()(e3, { e3 }, 1))
assert(not xml_selector("E[foo$=\"bar\"]"):apply()(e4, { e4 }, 1))
assert(    xml_selector("E[foo$=\"bar\"]"):apply()(e5, { e5 }, 1))
assert(not xml_selector("E[foo$=\"bar\"]"):apply()(e6, { e6 }, 1))
assert(not xml_selector("E[foo$=\"bar\"]"):apply()(e7, { e7 }, 1))
assert(    xml_selector("E[foo*=\"bar\"]"):apply()(e3, { e3 }, 1))
assert(not xml_selector("E[foo*=\"bar\"]"):apply()(e4, { e4 }, 1))
assert(    xml_selector("E[foo*=\"bar\"]"):apply()(e5, { e5 }, 1))
assert(    xml_selector("E[foo*=\"bar\"]"):apply()(e6, { e6 }, 1))
assert(    xml_selector("E[foo*=\"bar\"]"):apply()(e7, { e7 }, 1))
assert(not xml_selector("E[foo|=\"en\"]") :apply()(e3, { e3 }, 1))
assert(not xml_selector("E[foo|=\"en\"]") :apply()(e4, { e4 }, 1))
assert(    xml_selector("E[foo|=\"en\"]") :apply()(e8, { e8 }, 1))
assert(    xml_selector("E[foo|=\"en\"]") :apply()(e9, { e9 }, 1))
assert(not xml_selector("E.warning")      :apply()(e1, { e1 }, 1))
assert(not xml_selector("E.warning")      :apply()(e3, { e3 }, 1))
assert(not xml_selector("E.warning")      :apply()(e10, { e10 }, 1))
assert(not xml_selector("E.warning")      :apply()(e11, { e11 }, 1))
assert(    xml_selector("E.warning")      :apply()(e12, { e12 }, 1))
assert(not xml_selector("*.warning")      :apply()(e1, { e1 }, 1))
assert(not xml_selector("*.warning")      :apply()(e3, { e3 }, 1))
assert(not xml_selector("*.warning")      :apply()(e10, { e10 }, 1))
assert(not xml_selector("*.warning")      :apply()(e11, { e11 }, 1))
assert(    xml_selector("*.warning")      :apply()(e12, { e12 }, 1))
assert(not xml_selector(".warning")       :apply()(e1, { e1 }, 1))
assert(not xml_selector(".warning")       :apply()(e3, { e3 }, 1))
assert(not xml_selector(".warning")       :apply()(e10, { e10 }, 1))
assert(not xml_selector(".warning")       :apply()(e11, { e11 }, 1))
assert(    xml_selector(".warning")       :apply()(e12, { e12 }, 1))
assert(not xml_selector("E#myid")         :apply()(e1, { e1 }, 1))
assert(not xml_selector("E#myid")         :apply()(e3, { e3 }, 1))
assert(not xml_selector("E#myid")         :apply()(e13, { e13 }, 1))
assert(    xml_selector("E#myid")         :apply()(e14, { e14 }, 1))
assert(not xml_selector("*#myid")         :apply()(e1, { e1 }, 1))
assert(not xml_selector("*#myid")         :apply()(e3, { e3 }, 1))
assert(not xml_selector("*#myid")         :apply()(e13, { e13 }, 1))
assert(    xml_selector("*#myid")         :apply()(e14, { e14 }, 1))
assert(not xml_selector("#myid")          :apply()(e1, { e1 }, 1))
assert(not xml_selector("#myid")          :apply()(e3, { e3 }, 1))
assert(not xml_selector("#myid")          :apply()(e13, { e13 }, 1))
assert(    xml_selector("#myid")          :apply()(e14, { e14 }, 1))
assert(not xml_selector("E F")            :apply()(e1, { e1, e1 }, 2))
assert(    xml_selector("E F")            :apply()(e2, { e1, e2 }, 2))
assert(not xml_selector("E F")            :apply()(e2, { e2, e2 }, 2))
assert(    xml_selector("E F")            :apply()(e2, { e1, e2, e2 }, 3))
assert(not xml_selector("E>F")            :apply()(e1, { e1, e1 }, 2))
assert(    xml_selector("E>F")            :apply()(e2, { e1, e2 }, 2))
assert(not xml_selector("E>F")            :apply()(e2, { e2, e2 }, 2))
assert(not xml_selector("E>F")            :apply()(e2, { e1, e2, e2 }, 3))
assert(    xml_selector("D,E")            :apply()(e1, { e1 }, 1))
assert(not xml_selector("D,E")            :apply()(e2, { e2 }, 1))
assert(    xml_selector("A,B,C,D,E")      :apply()(e1, { e1 }, 1))
assert(not xml_selector("A,B,C,D,E")      :apply()(e2, { e2 }, 1))
assert(not xml_selector(":not(E)")        :apply()(e1, { e1 }, 1))
assert(    xml_selector(":not(E)")        :apply()(e2, { e2 }, 1))

assert(not xml_selector("[foo=bar]>[foo='42']>[foo^=bar]"):apply()(e5, { e3, e4, e5 }, 3))
assert(    xml_selector("[foo=bar]>[foo='42']>[foo^=bar]"):apply()(e6, { e3, e4, e6 }, 3))
assert(not xml_selector("[foo=bar]>[foo='42']>[foo^=bar]"):apply()(e5, { e3, e3, e5 }, 3))
assert(not xml_selector("[foo=bar] [foo='42'] [foo^=bar]"):apply()(e5, { e3, e4, e5 }, 3))
assert(    xml_selector("[foo=bar] [foo='42'] [foo^=bar]"):apply()(e6, { e3, e4, e6 }, 3))
assert(not xml_selector("[foo=bar] [foo='42'] [foo^=bar]"):apply()(e5, { e3, e3, e5 }, 3))
assert(not xml_selector("[foo~='42'][foo~=bar][foo~='69']"):apply()(e5, { e5 }, 1))
assert(not xml_selector("[foo~='42'][foo~=bar][foo~='69']"):apply()(e6, { e6 }, 1))
assert(    xml_selector("[foo~='42'][foo~=bar][foo~='69']"):apply()(e7, { e7 }, 1))
