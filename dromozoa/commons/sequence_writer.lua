-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local function write(self, i, j, n, value, ...)
  j = j + 1
  local t = type(value)
  if t == "string" or t == "number" then
    i = i + 1
    self[i] = value
    if j < n then
      return write(self, i, j, n, ...)
    else
      return self
    end
  else
    error("bad argument #" .. j .. " to 'write' (string expected, got " .. t .. ")")
  end
end

local class = {}

function class.new()
  return {}
end

function class:write(...)
  return write(self, #self, 0, select("#", ...), ...)
end

function class:concat()
  return table.concat(self)
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
