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

local floor = math.floor

local function encode(year, month, day, hour, min, sec)
  if hour == nil then
    hour = 12
  end
  if min == nil then
    min = 0
  end
  if sec == nil then
    sec = 0
  end

  if month < 3 then
    year = year - 1
    month = month + 13
  else
    month = month + 1
  end

  local A = floor(year / 100)
  local time = floor(365.25 * year) + floor(30.6001 * month) + day - 719591 - A + floor(A / 4)
  return time * 86400 + hour * 3600 + min * 60 + sec
end

local function decode(time)
  local sec = time % 60
  time = (time - sec) / 60
  local min = time % 60
  time = (time - min) / 60
  local hour = time % 24
  time = (time - hour) / 24

  local alpha = floor((time + 573371.75) / 36524.25)
  local B = time + 2442113 + alpha - floor(alpha / 4)
  local C = floor((B - 122.1) / 365.25)
  local D = floor(365.25 * C)
  local E = floor((B - D) / 30.6001)

  local day = B - D - floor(30.6001 * E)
  local month
  if E < 14 then
    month = E - 1
  else
    month = E - 13
  end
  local year
  if month < 3 then
    year = C - 4715
  else
    year = C - 4716
  end

  return {
    year = year;
    month = month;
    day = day;
    hour = hour;
    min = min;
    sec = sec;
  }
end

local class = {}

function class.encode(calendar, timezone)
  if timezone == nil then
    timezone = 0
  end
  return encode(calendar.year, calendar.month, calendar.day, calendar.hour, calendar.min, calendar.sec) - timezone
end

function class.decode(time, timezone)
  if timezone == nil then
    timezone = 0
  end
  return decode(time + timezone)
end

return class
