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

local hash_table_impl = require "dromozoa.commons.hash_table_impl"

local private_impl = function () end

local class = {}

function class.new(hasher)
  return {
    [private_impl] = hash_table_impl(hasher);
  }
end

function class:get(key)
  if key == nil then
    return nil
  end
  local t = type(key)
  if t == "number" or t == "string" or t == "boolean" then
    return rawget(self, key)
  else
    local impl = self[private_impl]
    return impl:get(key)
  end
end

function class:each()
  return coroutine.wrap(function ()
    for k, v in next, self do
      if k == private_impl then
        for k, v in v:each() do
          coroutine.yield(k, v)
        end
      else
        coroutine.yield(k, v)
      end
    end
  end)
end

function class:insert(key, value, overwrite)
  if key == nil then
    error "table index is nil"
  end
  if value == nil then
    value = true
  end
  local t = type(key)
  if t == "number" or t == "string" or t == "boolean" then
    local v = rawget(self, key)
    if v == nil or overwrite then
      rawset(self, key, value)
    end
    return v
  else
    local impl = self[private_impl]
    return impl:insert(key, value, overwrite)
  end
end

function class:remove(key)
  if key == nil then
    error "table index is nil"
  end
  local t = type(key)
  if t == "number" or t == "string" or t == "boolean" then
    local v = rawget(self, key)
    rawset(self, key, nil)
    return v
  else
    local impl = self[private_impl]
    return impl:remove(key)
  end
end

function class:set(key, value)
  if value == nil then
    return class.remove(self, key)
  else
    return class.insert(self, key, value, true)
  end
end

class.metatable = {
  __newindex = class.set;
  __pairs = class.each;
}

function class.metatable:__index(key)
  local v = class.get(self, key)
  if v == nil then
    return class[key]
  else
    return v
  end
end

return setmetatable(class, {
  __call = function (_, hasher)
    return setmetatable(class.new(hasher), class.metatable)
  end;
})
