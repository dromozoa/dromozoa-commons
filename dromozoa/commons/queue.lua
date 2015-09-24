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

local private_min = function () end
local private_max = function () end

local function push(self, n, value, ...)
  if value == nil then
    self[private_max] = n
    return self
  else
    n = n + 1
    self[n] = value
    return push(self, n, ...)
  end
end

function class.new()
  return {
    [private_min] = 1;
    [private_max] = 0;
  }
end

function class:empty()
  return self[private_min] > self[private_max]
end

function class:front()
  return self[self[private_min]]
end

function class:push(...)
  return push(self, self[private_max], ...)
end

function class:pop()
  local n = self[private_min]
  local v = self[n]
  self[n] = nil
  self[private_min] = n + 1
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
  local n = self[private_max]
  for i = i, j do
    n = n + 1
    self[n] = that[i]
  end
  self[private_max] = n
  return self
end

function class:each()
  return coroutine.wrap(function ()
    for i = self[private_min], self[private_max] do
      coroutine.yield(self[i])
    end
  end)
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
