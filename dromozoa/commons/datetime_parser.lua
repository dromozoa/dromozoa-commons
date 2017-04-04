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

local lua_version_num = require "dromozoa.commons.lua_version_num"
local string_matcher = require "dromozoa.commons.string_matcher"

local months = {
  Jan = 1; Feb = 2; Mar = 3; Apr = 4; May = 5; Jun = 6;
  Jul = 7; Aug = 8; Sep = 9; Oct = 10; Nov = 11; Dec = 12;
}

local class = {}

function class.new(this)
  if type(this) == "string" then
    this = string_matcher(this)
  end
  return {
    this = this;
  }
end

function class:raise(message)
  if message == nil then
    message = "parse error"
  end
  error(message .. " at position " .. self.this.position)
end

function class:parse()
  local this = self.this
  local datetime = {}
  local offset
  if this:match("(%d%d%d%d+)%-(%d%d)%-(%d%d)") then
    datetime.year = tonumber(this[1])
    datetime.month = tonumber(this[2])
    datetime.day = tonumber(this[3])
    if this:match("[T ](%d%d)%:(%d%d)") then
      datetime.hour = tonumber(this[1])
      datetime.min = tonumber(this[2])
      if this:match("%:(%d%d)") then
        datetime.sec = tonumber(this[1])
        if this:match("%.(%d%d?%d?%d?%d?%d?%d?%d?%d?)") then
          local decimal_part = this[1]
          datetime.nsec = tonumber(decimal_part) * 10 ^ (9 - #decimal_part)
        end
      end
      if this:match("Z") then
        offset = 0
      elseif this:match("([%+%-])(%d%d)%:?(%d%d)") then
        offset = tonumber(this[2]) * 3600 + tonumber(this[3]) * 60
        if this[1] == "-" then
          offset = -offset
        end
      end
    end
  elseif this:match("(%d%d)%/(%u%l%l)%/(%d%d%d%d+)%:(%d%d)%:(%d%d)%:(%d%d) ([%+%-])(%d%d)(%d%d)") then
    datetime.day = tonumber(this[1])
    local month = months[this[2]]
    if month == nil then
      self:raise("invalid month")
    end
    datetime.month = month
    datetime.year = tonumber(this[3])
    datetime.hour = tonumber(this[4])
    datetime.min = tonumber(this[5])
    datetime.sec = tonumber(this[6])
    offset = tonumber(this[8]) * 3600 + tonumber(this[9]) * 60
    if this[7] == "-" then
      offset = -offset
    end
  else
    self:raise()
  end
  return datetime, offset, this
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, this)
    return setmetatable(class.new(this), class.metatable)
  end;
})
