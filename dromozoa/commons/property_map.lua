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

local empty = require "dromozoa.commons.empty"
local pairs = require "dromozoa.commons.pairs"

local class = {}

function class.new()
  return {
    dataset = {};
  }
end

function class:clear(key)
  self.dataset[key] = nil
end

function class:remove(handle)
  local dataset = self.dataset
  for key, data in pairs(self.dataset) do
    data[handle] = nil
    if empty(data) then
      dataset[key] = nil
    end
  end
end

function class:each(key)
  local data = self.dataset[key]
  if data then
    return coroutine.wrap(function ()
      for handle, value in pairs(data) do
        coroutine.yield(handle)
      end
    end)
  else
    return function () end
  end
end

function class:set_property(handle, key, value)
  local dataset = self.dataset
  local data = dataset[key]
  if data == nil then
    data = {}
    dataset[key] = data
  end
  local v = data[handle]
  data[handle] = value
  if empty(data) then
    dataset[key] = nil
  end
  return v
end

function class:get_property(handle, key)
  local data = self.dataset[key]
  if data then
    return data[handle]
  end
end

function class:each_property(handle)
  return coroutine.wrap(function ()
    for key, data in pairs(self.dataset) do
      local value = data[handle]
      if value ~= nil then
        coroutine.yield(key, value)
      end
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
