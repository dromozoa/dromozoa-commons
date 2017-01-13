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

local pairs = require "dromozoa.commons.pairs"
local sequence = require "dromozoa.commons.sequence"
local set = require "dromozoa.commons.set"

local super = set
local class = {}

function class:set(i, j)
  if j == nil then
    j = i
  end
  for i = i, j do
    self[i] = true
  end
  return self
end

function class:reset(i, j)
  if j == nil then
    j = i
  end
  for i = i, j do
    self[i] = nil
  end
  return self
end

function class:flip(i, j)
  if j == nil then
    j = i
  end
  for i = i, j do
    if self[i] == nil then
      self[i] = true
    else
      self[i] = nil
    end
  end
  return self
end

function class:test(i)
  return self[i] ~= nil
end

function class:each()
  return pairs(self)
end

function class:count()
  local n = 0
  for _ in pairs(self) do
    n = n + 1
  end
  return n
end

function class:bounds()
  local min
  local max
  for k in pairs(self) do
    if min == nil or min > k then
      min = k
    end
    if max == nil or max < k then
      max = k
    end
  end
  return min, max
end

function class:ranges()
  local ranges = sequence()
  local min, max = class.bounds(self)
  if min == nil then
    return ranges
  end
  local a = min
  local b = min
  for i = min + 1, max do
    if self[i] ~= nil then
      if b ~= i - 1 then
        ranges:push({ a, b })
        a = i
      end
      b = i
    end
  end
  ranges:push({ a, b })
  return ranges
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __index = super;
  __call = function (_, self)
    return setmetatable(class.new(self), class.metatable)
  end;
})
