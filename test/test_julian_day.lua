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

local json = require "dromozoa.commons.json"
local julian_day = require "dromozoa.commons.julian_day"

local DBL_EPSILON = 2.2204460492503131e-16

assert(julian_day.encode(1999, 12, 31) == 2451544)
assert(julian_day.encode(2000, 1, 1) == 2451545)
assert(math.abs(julian_day.encode(2013, 1, 1, 0, 30) - 2456293.520833) < 0.000001)
assert(julian_day.encode(2017, 1, 16) == 2457770)

-- Astronomical Algorithms
assert(julian_day.encode(2000, 1, 1, 12) == 2451545)
assert(julian_day.encode(1999, 1, 1, 0) == 2451179.5)
assert(julian_day.encode(1987, 1, 27, 0) == 2446822.5)
assert(julian_day.encode(1987, 6, 19, 12) == 2446966)
assert(julian_day.encode(1988, 1, 27, 0) == 2447187.5)
assert(julian_day.encode(1988, 6, 19, 12) == 2447332)
assert(julian_day.encode(1900, 1, 1, 0) == 2415020.5)
assert(julian_day.encode(1600, 1, 1, 0) == 2305447.5)
assert(julian_day.encode(1600, 12, 31, 0) == 2305812.5)
assert(julian_day.encode(837, 4, 10, 6) == 2026871.75)
assert(julian_day.encode(-123, 12, 31, 0) == 1676496.5)
assert(julian_day.encode(-122, 1, 1, 0) == 1676497.5)
assert(julian_day.encode(-1000, 7, 12, 12) == 1356001)
assert(julian_day.encode(-1000, 2, 29, 0) == 1355866.5)
assert(julian_day.encode(-1001, 8, 17, 18) == 1355671.25)
assert(julian_day.encode(-4712, 1, 1, 12) == 0)

assert(julian_day.encode(1582, 10, 4, 12) == 2299160)
assert(julian_day.encode(1582, 10, 4, 23, 15) == 2299160.46875)
assert(julian_day.encode(1582, 10, 15, 0) == 2299160.5)
assert(julian_day.encode(1582, 10, 15, 0, 45) == 2299160.53125)
assert(julian_day.encode(1582, 10, 15, 12) == 2299161)

print(json.encode(julian_day.decode(2451544)))
print(json.encode(julian_day.decode(2451545)))
