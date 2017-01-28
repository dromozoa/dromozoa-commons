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
  day = day + hour / 24 + min / 1440 + sec / 86400

  local jd = floor(365.25 * (year + 4716)) + floor(30.6001 * month) + day - 1524.5
  if jd >= 2299160.5 then
    local A = floor(year / 100)
    jd = jd + 2 - A + floor(A / 4)
  end

  return jd
end

local function decode(jd)
  jd = jd + 1.5
  local F = jd % 1
  local A = jd - F
  local wday = A % 7
  if A >= 2299162 then
    local alpha = floor((A - 1867217.25) / 36524.25)
    A = A + 1 + alpha - floor(alpha / 4)
  end
  local B = A + 1523
  local C = floor((B - 122.1) / 365.25)
  local D = floor(365.25 * C)
  local E = floor((B - D) / 30.6001)

  local year
  local month
  if E < 14 then
    year = C - 4716
    month = E - 1
  else
    year = C - 4715
    month = E - 13
  end
  local day = B - D - floor(30.6001 * E)

  local time = floor(F * 86400 + 0.0001)
  local sec = time % 60
  time = (time - sec) / 60
  local min = time % 60
  time = (time - min) / 60
  local hour = time % 24

  return {
    year = year;
    month = month;
    day = day;
    hour = hour;
    min = min;
    sec = sec;
    wday = wday;
  }
end

local class = {}

function class.encode(datetime, offset)
  if offset == nil then
    offset = 0
  end
  return encode(datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, datetime.sec) - offset / 86400
end

function class.decode(jd, offset)
  if offset == nil then
    offset = 0
  end
  return decode(jd + offset / 86400)
end

return class
