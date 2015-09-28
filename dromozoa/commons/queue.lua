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

local push = require "dromozoa.commons.push"

local class = {}

function class.new()
  return {
    data = {};
    max = 0;
    min = 1;
  }
end

function class:front()
  return self.data[self.min]
end

function class:back()
  return self.data[self.max]
end

function class:push(...)
  self.max = push(self.data, self.max, ...)
  return self
end

function class:pop()
  local data = self.data
  local n = self.min
  local v = data[n]
  data[n] = nil
  self.min = n + 1
  return v
end

function class:copy(that, i, j)
  if i == nil then
    i = 1
  elseif i < 0 then
    i = #that + 1 + i
  end
  if j == nil then
    j = #that
  elseif j < 0 then
    j = #that + 1 + j
  end
  local data = self.data
  local n = self.max
  for i = i, j do
    n = n + 1
    data[n] = that[i]
  end
  self.max = n
  return self
end

function class:each()
  local data = self.data
  return coroutine.wrap(function ()
    for i = self.min, self.max do
      coroutine.yield(data[i])
    end
  end)
end

local metatable = {}

function metatable:__index(key)
  if type(key) == "number" then
    return self.data[key - 1 + self.min]
  else
    return class[key]
  end
end

function metatable:__pairs()
  local data = self.data
  local n = self.min - 1
  return coroutine.wrap(function ()
    for i = self.min, self.max do
      coroutine.yield(i, data[i])
    end
  end)
end

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
