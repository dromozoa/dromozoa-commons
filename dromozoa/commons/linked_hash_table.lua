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
local hash_table_pair = require "dromozoa.commons.hash_table_pair"

local private_base = function () end
local private_impl = function () end
local private_pair = function () end

local class = {}

function class.new(hasher)
  return {
    [private_base] = {};
    [private_impl] = hash_table_impl(hasher);
    [private_pair] = hash_table_pair();
  }
end

function class:identity(key)
  if key == nil then
    return nil
  end
  local t = type(key)
  if t == "number" or t == "string" or t == "boolean" then
    local base = self[private_base]
    return base[key]
  else
    local impl = self[private_impl]
    return impl:get(key)
  end
end

function class:find(handle)
  if handle == nil then
    return nil, nil
  end
  local pair = self[private_pair]
  return pair:find(handle)
end

function class:get(key)
  if key == nil then
    return nil
  end
  local pair = self[private_pair]
  local t = type(key)
  if t == "number" or t == "string" or t == "boolean" then
    local base = self[private_base]
    return pair:get(base[key])
  else
    local impl = self[private_impl]
    return pair:get(impl:get(key))
  end
end

function class:each()
  local pair = self[private_pair]
  return pair:each()
end

function class:insert(key, value, overwrite)
  if key == nil then
    error "table index is nil"
  end
  if value == nil then
    value = true
  end
  local pair = self[private_pair]
  local t = type(key)
  local h
  if t == "number" or t == "string" or t == "boolean" then
    local base = self[private_base]
    h = base[key]
    if h == nil then
      base[key] = pair:insert(key, value)
      return nil
    end
  else
    local impl = self[private_impl]
    h = impl:get(key)
    if h == nil then
      impl:insert(key, pair:insert(key, value))
      return nil
    end
  end
  if overwrite then
    return pair:set(h, value)
  else
    return pair:get(h, value)
  end
end

function class:remove(key)
  if key == nil then
    error "table index is nil"
  end
  local t = type(key)
  local h
  if t == "number" or t == "string" or t == "boolean" then
    local base = self[private_base]
    h = base[key]
    base[key] = nil
  else
    local impl = self[private_impl]
    h = impl:remove(key)
  end
  if h == nil then
    return nil
  end
  local pair = self[private_pair]
  return pair:remove(h)
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
  ["dromozoa.commons.is_stable"] = true;
}

function class.metatable:__index(key)
  local v = class.get(self, key)
  if v == nil then
    return class[key]
  else
    return v
  end
end

function class.metatable:__pairs()
  return coroutine.wrap(function ()
    for k, v in class.each(self) do
      coroutine.yield(k, v)
    end
  end)
end

return setmetatable(class, {
  __call = function (_, hasher)
    return setmetatable(class.new(hasher), class.metatable)
  end;
})
