-- Copyright (C) 2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local rb_tree = require "dromozoa.commons.rb_tree"

local private_impl = function () end

local class = {}

function class.new(compare)
  return {
    [private_impl] = rb_tree(compare);
  }
end

function class:get(key)
  if key == nil then
    return nil
  end
  local impl = self[private_impl]
  local h = impl:search(key)
  if h == nil then
    return nil
  else
    local _, v = impl:get(h)
    return v
  end
end

function class:each()
  local impl = self[private_impl]
  local a = impl:minimum()
  if a == nil then
    return function () end
  else
    local b = impl:maximum()
    return coroutine.wrap(function ()
      while true do
        local s = impl:successor(a)
        local k, v = impl:get(a)
        coroutine.yield(k, v)
        if a == b then
          break
        end
        a = s
      end
    end)
  end
end

function class:insert(key, value, overwrite)
  if key == nil then
    error "table index is nil"
  end
  if value == nil then
    value = true
  end
  local impl = self[private_impl]
  local h = impl:search(key)
  if h == nil then
    impl:insert(key, value)
    return nil
  else
    local _, v = impl:get(h)
    if overwrite then
      impl:set(h, value)
    end
    return v
  end
end

function class:remove(key)
  if key == nil then
    error "table index is nil"
  end
  local impl = self[private_impl]
  local h = impl:search(key)
  if h == nil then
    return nil
  else
    local _, v = impl:get(h)
    impl:delete(h)
    return v
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

return setmetatable(class, {
  __index = super;
  __call = function (_, compare)
    return setmetatable(class.new(compare), class.metatable)
  end;
})
