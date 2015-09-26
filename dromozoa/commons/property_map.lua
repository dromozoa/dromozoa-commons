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

local pairs = require "dromozoa.commons.pairs"

local function construct(constructor)
  if constructor == nil then
    return {}
  else
    return constructor()
  end
end

local class = {}

function class.new(dataset_constructor, data_constructor)
  print(dataset_constructor, data_constructor)
  return {
    dataset = construct(dataset_constructor);
    data_constructor = data_constructor;
  }
end

function class:clear(key)
  self.dataset[key] = nil
end

function class:remove(handle)
  for key, data in pairs(self.dataset) do
    data[handle] = nil
    if next(data) == nil then
      self[key] = nil
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
    data = construct(self.data_constructor)
    dataset[key] = data
  end
  local v = data[handle]
  data[handle] = value
  if next(data) == nil then
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
  __call = function (_, dataset_constructor, data_constructor)
    return setmetatable(class.new(dataset_constructor, data_constructor), metatable)
  end;
})
