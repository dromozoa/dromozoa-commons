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
local ipairs = require "dromozoa.commons.ipairs"
local push = require "dromozoa.commons.push"

local class = {}

function class.new(self)
  if self == nil then
    return {}
  else
    return self
  end
end

function class:top()
  return self[#self]
end

function class:push(...)
  push(self, #self, ...)
  return self
end

function class:pop()
  local n = #self
  local v = self[n]
  self[n] = nil
  return v
end

function class:copy(that, i, j)
  copy(self, #self, that, i, j)
  return self
end

function class:sort(compare)
  table.sort(self, compare)
  return self
end

function class:concat(sep)
  return table.concat(self, sep)
end

function class:each()
  return coroutine.wrap(function ()
    for _, v in ipairs(self) do
      coroutine.yield(v)
    end
  end)
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, self)
    return setmetatable(class.new(self), class.metatable)
  end;
})
