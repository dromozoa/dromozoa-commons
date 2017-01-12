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

local copy = require "dromozoa.commons.copy"
local push = require "dromozoa.commons.push"

local class = {}

function class.new()
  return {
    min = 1;
    max = 0;
  }
end

function class:front()
  return self[self.min]
end

function class:back()
  return self[self.max]
end

function class:push(...)
  self.max = push(self, self.max, ...)
  return self
end

function class:pop()
  local n = self.min
  local v = self[n]
  self[n] = nil
  self.min = n + 1
  return v
end

function class:copy(that, i, j)
  self.max = copy(self, self.max, that, i, j)
  return self
end

function class:each()
  return coroutine.wrap(function ()
    for i = self.min, self.max do
      coroutine.yield(self[i])
    end
  end)
end

class.metatable = {
  __index = class;
}

function class.metatable:__pairs()
  return coroutine.wrap(function ()
    for i = self.min, self.max do
      coroutine.yield(i, self[i])
    end
  end)
end

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), class.metatable)
  end;
})
