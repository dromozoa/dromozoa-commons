-- Copyright (C) 2015,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local function write(data, i, j, n, value, ...)
  if j < n then
    j = j + 1
    local t = type(value)
    if t == "string" or t == "number" then
      i = i + 1
      data[i] = value
      return write(data, i, j, n, ...)
    else
      error("bad argument #" .. j .. " to 'write' (string expected, got " .. t .. ")")
    end
  else
    return data
  end
end

local class = {}

function class.new(self)
  if self == nil then
    return {}
  else
    return self
  end
end

function class:write(...)
  return write(self, #self, 0, select("#", ...), ...)
end

function class:concat(sep)
  return table.concat(self, sep)
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, self)
    return setmetatable(class.new(self), class.metatable)
  end;
})
