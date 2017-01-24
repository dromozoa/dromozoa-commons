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

local equal = require "dromozoa.commons.equal"
local julian_day = require "dromozoa.commons.julian_day"
local unpack = require "dromozoa.commons.unpack"

assert(math.abs(julian_day.encode({ year = 2013, month = 1, day = 1, hour = 0, min = 30 }) - 2456293.520833) < 0.000001)

local function test(jd, year, month, day, hour, min, sec)
  local calendar = {
    year = year;
    month = month;
    day = day;
    hour = hour;
    min = min;
    sec = sec;
  }
  local result = julian_day.encode(calendar)
  assert(result == jd)
  if calendar.hour == nil then
    calendar.hour = 12
  end
  if calendar.min == nil then
    calendar.min = 0
  end
  if calendar.sec == nil then
    calendar.sec = 0
  end
  local result = julian_day.decode(jd)
  assert(equal(result, calendar))
end

-- wikipedia
test(2451544, 1999, 12, 31)
test(2451545, 2000, 1, 1)
test(2457770, 2017, 1, 16)

-- Astronomical Algorithms
test(2451545, 2000, 1, 1, 12)
test(2451179.5, 1999, 1, 1, 0)
test(2446822.5, 1987, 1, 27, 0)
test(2446966, 1987, 6, 19, 12)
test(2447187.5, 1988, 1, 27, 0)
test(2447332, 1988, 6, 19, 12)
test(2415020.5, 1900, 1, 1, 0)
test(2305447.5, 1600, 1, 1, 0)
test(2305812.5, 1600, 12, 31, 0)
test(2026871.75, 837, 4, 10, 6)
test(1676496.5, -123, 12, 31, 0)
test(1676497.5, -122, 1, 1, 0)
test(1356001, -1000, 7, 12, 12)
test(1355866.5, -1000, 2, 29, 0)
test(1355671.25, -1001, 8, 17, 18)
test(0, -4712, 1, 1, 12)

test(2299160, 1582, 10, 4, 12)
test(2299160.46875, 1582, 10, 4, 23, 15)
test(2299160.5, 1582, 10, 15, 0)
test(2299160.53125, 1582, 10, 15, 0, 45)
test(2299161, 1582, 10, 15, 12)

local jd = julian_day.encode({ year = 1999, month = 1, day = 1, hour = 0 })
local t = 915148800
for i = 0, 86400 do
  local jd = jd + i / 86400
  local t = t + i
  local result1 = julian_day.decode(jd)
  local result2 = ("%d-%02d-%02d %02d:%02d:%02d"):format(result1.year, result1.month, result1.day, result1.hour, result1.min, result1.sec)
  local result3 = os.date("!%Y-%m-%d %H:%M:%S", t)
  assert(result2 == result3)
  local result4 = julian_day.encode(result1)
  assert(jd == result4)
  local result5 = julian_day.decode(result4)
  assert(equal(result1, result5))
  local result6 = julian_day.decode(jd, 32400)
  local result7 = ("%d-%02d-%02d %02d:%02d:%02d"):format(result6.year, result6.month, result6.day, result6.hour, result6.min, result6.sec)
  local result8 = os.date("%Y-%m-%d %H:%M:%S", t)
  assert(result7 == result8)
  local result9 = julian_day.encode(result6, 32400)
  assert(jd == result9)
end
