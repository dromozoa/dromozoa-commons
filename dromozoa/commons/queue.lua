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

local class = {}

local private_min = "min"
local private_max = "max"

local function push(data, n, value, ...)
  if value == nil then
    return n
  else
    n = n + 1
    data[n] = value
    return push(data, n, ...)
  end
end

function class.new()
  return {
    min = 1;
    max = 0;
    data = {};
  }
end

function class:empty()
  return self.min > self.max
end

function class:front()
  return self.data[self.min]
end

function class:push(...)
  self.max = push(self.data, self.max, ...)
  return self
end

function class:pop()
  local n = self.min
  local v = self.data[n]
  self.data[n] = nil
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
  local n = self.max
  for i = i, j do
    n = n + 1
    self.data[n] = that[i]
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

local metatable = {
  __index = class;
}

function metatable:__pairs()
  local data = self.data
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
