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

local class = {}

function class.new(self)
  if self == nil then
    return {}
  else
    return self
  end
end

function class:includes(that)
  for k, v in pairs(that) do
    if self[k] == nil then
      return false
    end
  end
  return true
end

function class:intersection(that)
  local n = 0
  for k in pairs(self) do
    if that[k] == nil then
      n = n + 1
      self[k] = nil
    end
  end
  return n
end

function class:difference(that)
  local n = 0
  for k in pairs(self) do
    if that[k] ~= nil then
      n = n + 1
      self[k] = nil
    end
  end
  return n
end

function class:union(that)
  local n = 0
  for k, v in pairs(that) do
    if self[k] == nil then
      n = n + 1
      self[k] = v
    end
  end
  return n
end

function class:symmetric_difference(that)
  local n = 0
  for k, v in pairs(that) do
    n = n + 1
    if self[k] == nil then
      self[k] = v
    else
      self[k] = nil
    end
  end
  return n
end

function class:set_intersection(that)
  class.intersection(self, that)
  return self
end

function class:set_difference(that)
  class.difference(self, that)
  return self
end

function class:set_union(that)
  class.union(self, that)
  return self
end

function class:set_symmetric_difference(that)
  class.symmetric_difference(self, that)
  return self
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, self)
    return setmetatable(class.new(self), class.metatable)
  end;
})
