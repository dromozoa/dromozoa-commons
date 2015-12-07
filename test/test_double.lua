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

local double = require "dromozoa.commons.double"
local equal = require "dromozoa.commons.equal"

local function test(this, that)
  assert(equal({ double.word(this) }, that))
  assert(equal({ double.word(this, "<") }, that))
  assert(equal({ double.word(this, ">") }, { that[2], that[1] }))
end

local DBL_MAX = 1.7976931348623157e+308
local DBL_DENORM_MIN = 4.9406564584124654e-324
local DBL_MIN = 2.2250738585072014e-308
local DBL_EPSILON = 2.2204460492503131e-16

test(42,             { 0x00000000, 0x40450000 })
test(DBL_MAX,        { 0xffffffff, 0x7fefffff })
test(DBL_DENORM_MIN, { 0x00000001, 0x00000000 })
test(DBL_MIN,        { 0x00000000, 0x00100000 })
test(DBL_EPSILON,    { 0x00000000, 0x3cb00000 })
test(math.pi,        { 0x54442d18, 0x400921fb })
test(0,              { 0x00000000, 0x00000000 })
test(-1 / math.huge, { 0x00000000, 0x80000000 })
test(math.huge,      { 0x00000000, 0x7ff00000 })
test(-math.huge,     { 0x00000000, 0xfff00000 })
test(0 / 0,          { 0x00000000, 0xfff80000 })
