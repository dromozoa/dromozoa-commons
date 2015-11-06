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

local apply = require "dromozoa.commons.apply"
local bitset = require "dromozoa.commons.bitset"
local ipairs = require "dromozoa.commons.ipairs"
local pairs = require "dromozoa.commons.pairs"

assert(apply(pairs({})) == nil)
assert(apply(pairs({17})) == 1)
assert(apply(pairs({foo = 17})) == "foo")
assert(apply(ipairs({17, 23, 37})) == 1)
assert(select(2, apply(ipairs({17, 23, 37}))) == 17)
assert(apply(bitset():set(42):each()) == 42)
