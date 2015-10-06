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

local bitset = require "dromozoa.commons.bitset"
local equal = require "dromozoa.commons.equal"

local bs = bitset():set(2, 4)
assert(equal(bs, { [2] = true, [3] = true, [4] = true }))
assert(not bs:test(1))
assert(bs:test(2))
assert(bs:test(3))
assert(bs:test(4))
assert(not bs:test(5))
bs:reset(3)
assert(equal(bs, { [2] = true, [4] = true }))
bs:flip(1, 5)
assert(equal(bs, { [1] = true, [3] = true, [5] = true }))

assert(bs:includes(bitset():set(1)))
assert(not bs:includes(bitset():set(1, 5)))

local bs = bitset():set(1, 2):union(bitset():set(2, 3))
assert(equal(bs, { [1] = true, [2] = true, [3] = true }))
bs:intersection(bitset():set(2, 4))
assert(equal(bs, { [2] = true, [3] = true }))
bs:symmetric_difference(bitset():set(3, 4))
assert(equal(bs, { [2] = true, [4] = true }))
bs:difference(bitset():set(1, 3))
assert(equal(bs, { [4] = true }))
