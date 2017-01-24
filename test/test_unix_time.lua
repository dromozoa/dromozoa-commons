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
local json = require "dromozoa.commons.json"
local unix_time = require "dromozoa.commons.unix_time"

local function test(time, calendar, timezone)
  local result1 = unix_time.encode(calendar, timezone)
  -- print(result1, time)
  assert(result1 == time)

  if calendar.hour == nil then
    calendar.hour = 12
  end
  if calendar.min == nil then
    calendar.min = 0
  end
  if calendar.sec == nil then
    calendar.sec = 0
  end
  local result2 = unix_time.decode(time, timezone)
  -- print(json.encode(result2))
  -- print(json.encode(calendar))
  assert(equal(result2, calendar))
end

local function test_utc(time, year, month, day, hour, min, sec)
  test(time, {
    year = year;
    month = month;
    day = day;
    hour = hour;
    min = min;
    sec = sec;
  })
end

local function test_jst(time, year, month, day, hour, min, sec)
  test(time, {
    year = year;
    month = month;
    day = day;
    hour = hour;
    min = min;
    sec = sec;
  }, 32400)
end

test_utc(0, 1970, 1, 1, 0)
test_utc(100000000, 1973, 3, 3, 9, 46, 40)
test_utc(1000000000, 2001, 9, 9, 1, 46, 40)
test_utc(1234567890, 2009, 2, 13, 23, 31, 30)
test_utc(2147483647, 2038, 1, 19, 3, 14, 7)

test_jst(0, 1970, 1, 1, 9)
test_jst(100000000, 1973, 3, 3, 18, 46, 40)
test_jst(1000000000, 2001, 9, 9, 10, 46, 40)
test_jst(1234567890, 2009, 2, 14, 8, 31, 30)
test_jst(2147483647, 2038, 1, 19, 12, 14, 7)
