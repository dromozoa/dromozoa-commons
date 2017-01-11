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

local push = require "dromozoa.commons.push"

local function match(self, i, j, ...)
  self.i = i
  self.j = j
  local n = push(self, 0, ...)
  for i = n + 1, #self do
    self[i] = nil
  end
  return j ~= nil
end

local class = {}

function class.new(s, position)
  if position == nil then
    position = 1
  end
  return {
    s = s;
    j = 0;
    position = position;
  }
end

function class:match(pattern)
  if match(self, self.s:find("^" .. pattern, self.position)) then
    self.position = self.j + 1
    return true
  else
    return false
  end
end

function class:lookahead(pattern)
  return match(self, self.s:find("^" .. pattern, self.position))
end

function class:eof()
  return self.position > #self.s
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, s, position)
    return setmetatable(class.new(s, position), class.metatable)
  end;
})
