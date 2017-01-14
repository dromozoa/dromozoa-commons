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

local multimap_handle = require "dromozoa.commons.multimap_handle"
local rb_tree = require "dromozoa.commons.rb_tree"

local private_impl = function () end

local class = {}

function class.new(compare)
  return {
    [private_impl] = rb_tree(compare);
  }
end

function class:insert(k, v)
  local impl = self[private_impl]
  local h = impl:insert(k, v)
  return multimap_handle(impl, h)
end

function class:lower_bound(k)
  local impl = self[private_impl]
  local h = impl:lower_bound(k)
  if h == nil then
    return multimap_handle(impl)
  end
  return multimap_handle(impl, h, impl:maximum())
end

function class:upper_bound(k)
  local impl = self[private_impl]
  local h = impl:upper_bound(k)
  if h == nil then
    return multimap_handle(impl)
  end
  return multimap_handle(impl, impl:minimum(), h)
end

function class:equal_range(k)
  local impl = self[private_impl]
  local h = impl:search(k)
  if h == nil then
    return multimap_handle(impl)
  else
    return multimap_handle(impl, h, impl:upper_bound(k))
  end
end

function class:each()
  local impl = self[private_impl]
  local a = impl:minimum()
  if a == nil then
    return function () end
  else
    local b = impl:maximum()
    local that = multimap_handle(impl)
    return coroutine.wrap(function ()
      while true do
        local s = impl:successor(a)
        local k, v = impl:get(a)
        coroutine.yield(k, v, that:reset(a))
        if a == b then
          break
        end
        a = s
      end
    end)
  end
end

function class:empty()
  local impl = self[private_impl]
  return impl:empty()
end

function class:single()
  local impl = self[private_impl]
  return impl:single()
end

function class:head()
  local impl = self[private_impl]
  local h = impl:minimum()
  if h ~= nil then
    return impl:get(h)
  end
end

function class:tail()
  local impl = self[private_impl]
  local h = impl:maximum()
  if h ~= nil then
    return impl:get(h)
  end
end

class.metatable = {
  __index = class;
  ["dromozoa.commons.is_stable"] = true;
}

function class.metatable:__pairs()
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

return setmetatable(class, {
  __call = function (_, compare)
    return setmetatable(class.new(compare), class.metatable)
  end;
})
