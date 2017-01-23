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

local class = {}

local floor = math.floor

function class.encode(year, month, day, hour, min, sec)
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
    month = month + 12
  end
  day = day + hour / 24 + min / 1440 + sec / 86400

  local jd = floor(365.25 * (year + 4716)) + floor(30.6001 * (month + 1)) + day - 1524.5
  if jd >= 2299160.5 then
    local A = floor(year / 100)
    local B = 2 - A + floor(A / 4)
    jd = jd + B
  end

  return jd
end

function class.decode(jd)
  jd = jd + 0.5
  local F = jd % 1
  local A = jd - F
  if A >= 2299161 then
    local alpha = floor((A - 1867216.25) / 36524.25)
    A = A + 1 + alpha - floor(alpha / 4)
  end
  local B = A + 1524
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

  local hour = F * 24
  local min = hour % 1
  hour = hour - min
  min = min * 60
  local sec = min % 1
  min = min - sec
  sec = floor(sec * 60)

  return year, month, day, hour, min, sec
end

return class
