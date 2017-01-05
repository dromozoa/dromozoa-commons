-- Copyright (C) 2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local is_array = require "dromozoa.commons.is_array"

assert(is_array({}) == 0)
assert(is_array({ 17, 23, 37, 42, 69 }) == 5)
assert(is_array({ 17, nil, 23, nil, 37, nil, 42, nil, 69 }) == 9)
assert(is_array({ 17, nil, nil, 69}) == nil)
assert(is_array({ [0] = 42 }) == nil)
assert(is_array({ [1.5] = 42 }) == nil)
assert(is_array({ 42, foo = "bar" }) == nil)
