-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-bitset.
--
-- dromozoa-bitset is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-bitset is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-bitset.  If not, see <http://www.gnu.org/licenses/>.

local clone = require "dromozoa.commons.clone"
local pairs = require "dromozoa.commons.pairs"
local sequence = require "dromozoa.commons.sequence"
local set = require "dromozoa.commons.set"

local class = clone(set)

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
  local count = 0
  for _ in pairs(self) do
    count = count + 1
  end
  return count
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
  local i, j = class.bounds(self)
  for i = i, j do
    if self[i] ~= nil then
      local top = ranges:top()
      if top == nil or top[2] ~= i - 1 then
        ranges:push({ i, i })
      else
        top[2] = i
      end
    end
  end
  return ranges
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
