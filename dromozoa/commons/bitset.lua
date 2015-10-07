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
local set = require "dromozoa.commons.set"

local class = clone(set)

function class:set(min, max)
  if max == nil then
    max = min
  end
  for i = min, max do
    self[i] = true
  end
  return self
end

function class:reset(min, max)
  if max == nil then
    max = min
  end
  for i = min, max do
    self[i] = nil
  end
  return self
end

function class:flip(min, max)
  if max == nil then
    max = min
  end
  for i = min, max do
    if self[i] == nil then
      self[i] = true
    else
      self[i] = nil
    end
  end
  return self
end

function class:test(i)
  return self[i]
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

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
