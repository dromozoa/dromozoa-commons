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

local hash_table_impl = require "dromozoa.commons.hash_table.impl"
local hash_table_pair = require "dromozoa.commons.hash_table.pair"

local private_base = function () end
local private_impl = function () end
local private_pair = function () end

local class = {}

function class.new()
  return {
    [private_base] = {};
    [private_impl] = hash_table_impl();
    [private_pair] = hash_table_pair();
  }
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

function class:empty(key, value)
  local pair = self[private_pair]
  return pair:empty()
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

local metatable = {
  __newindex = class.set;
  __pairs = class.each;
}

function metatable:__index(key)
  local v = class.get(self, key)
  if v == nil then
    return class[key]
  else
    return v
  end
end

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
