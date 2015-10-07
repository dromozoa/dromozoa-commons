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

local clone = require "dromozoa.commons.clone"
local empty = require "dromozoa.commons.empty"
local locale = require "dromozoa.commons.locale"

local character_classes = locale.character_classes
assert(character_classes.xdigit)
assert(character_classes.punct:test(string.byte("[")))
assert(character_classes.punct:test(string.byte("|")))
assert(character_classes.punct:test(string.byte("]")))
assert(character_classes.punct:test(string.byte("~")))

assert(empty(clone(character_classes.cntrl):set_intersection(character_classes.alpha)))
assert(empty(clone(character_classes.cntrl):set_intersection(character_classes.print)))

local collating_elements = locale.collating_elements
assert(collating_elements.x00 == 0x00)
assert(collating_elements.xFF == 0xFF)
assert(collating_elements.a == string.byte("a"))
