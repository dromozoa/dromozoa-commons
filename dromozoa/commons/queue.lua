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

local function push(d, n, value, ...)
  if value == nil then
    return n
  else
    n = n + 1
    d[n] = value
    return push(d, n, ...)
  end
end

function class.new()
  return {
    data = {};
    max = 0;
    min = 1;
  }
end

function class:empty()
  return self.max < self.min
end

function class:front()
  return self.data[self.min]
end

function class:push(...)
  self.max = push(self.data, self.max, ...)
  return self
end

function class:pop()
  local d = self.data
  local n = self.min
  local v = d[n]
  d[n] = nil
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
  local d = self.data
  local n = self.max
  for i = i, j do
    n = n + 1
    d[n] = that[i]
  end
  self.max = n
  return self
end

function class:each()
  local d = self.data
  return coroutine.wrap(function ()
    for i = self.min, self.max do
      coroutine.yield(d[i])
    end
  end)
end

local metatable = {}

function metatable:__index(key)
  local n = self.min - 1
  if type(key) == "number" then
    return self.data[key + n]
  else
    return class[key]
  end
end

function metatable:__pairs()
  local d = self.data
  local n = self.min - 1
  return coroutine.wrap(function ()
    for i = self.min, self.max do
      coroutine.yield(i - n, d[i])
    end
  end)
end

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
