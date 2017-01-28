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

local datetime_parser = require "dromozoa.commons.datetime_parser"
local sequence_writer = require "dromozoa.commons.sequence_writer"

local floor = math.floor

local function write(out, year, month, day, hour, min, sec, nsec)
  if hour == nil then
    hour = 12
  end
  if min == nil then
    min = 0
  end
  if sec == nil then
    sec = 0
  end
  if nsec == nil then
    nsec = 0
  end
  out:write(("%04d-%02d-%02dT%02d:%02d"):format(year, month, day, hour, min))
  if sec ~= 0 or nsec ~= 0 then
    out:write((":%02d"):format(sec))
  end
  if nsec ~= 0 then
    out:write(((".%09d"):format(nsec):gsub("0+$", "")))
  end
  return out
end

local class = {}

function class.write(out, datetime, offset)
  write(out, datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, datetime.sec, datetime.nsec)
  if offset ~= nil then
    if offset == 0 then
      out:write("Z")
    else
      if offset > 0 then
        out:write("+")
      else
        out:write("-")
        offset = -offset
      end
      offset = floor(offset / 60)
      local min = offset % 60
      local hour = (offset - min) / 60
      out:write(("%02d:%02d"):format(hour, min))
    end
  end
  return out
end

function class.encode(datetime, offset)
  return class.write(sequence_writer(), datetime, offset):concat()
end

function class.parse(this)
  return datetime_parser(this):parse()
end

function class.decode(code)
  local datetime, offset, matcher = class.parse(code)
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return datetime, offset
end

return class
