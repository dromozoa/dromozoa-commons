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

function class:clear_key(key)
  local dataset = self.dataset
  dataset[key] = nil
end

function class:each_key()
  local dataset = self.dataset
  return next, dataset, nil
end

function class:remove_item(handle)
  local dataset = self.dataset
  for key, data in pairs(dataset) do
    data[handle] = nil
    if empty(data) then
      dataset[key] = nil
    end
  end
end

function class:each_item(key)
  local dataset = self.dataset
  local data = dataset[key]
  if data then
    return next, data, nil
  else
    return function () end
  end
end

function class:insert_property(handle, key, value)
  if handle == nil or key == nil then
    error "table index is nil"
  end
  local dataset = self.dataset
  local data = dataset[key]
  if data then
    local v = data[handle]
    data[handle] = value
    return v
  else
    dataset[key] = { [handle] = value }
    return nil
  end
end

function class:remove_property(handle, key)
  if handle == nil or key == nil then
    error "table index is nil"
  end
  local dataset = self.dataset
  local data = dataset[key]
  if data then
    local v = data[handle]
    data[handle] = nil
    if empty(data) then
      dataset[key] = nil
    end
    return v
  else
    return nil
  end
end

function class:set_property(handle, key, value)
  if value == nil then
    return class.remove_property(self, handle, key)
  else
    return class.insert_property(self, handle, key, value)
  end
end

function class:get_property(handle, key)
  local dataset = self.dataset
  local data = dataset[key]
  if data then
    return data[handle]
  end
end

function class:each_property(handle)
  local dataset = self.dataset
  return coroutine.wrap(function ()
    for key, data in pairs(dataset) do
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
