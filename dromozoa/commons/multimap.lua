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

local private_tree = function () end

local class = {}

function class.new(compare)
  return {
    [private_tree] = rb_tree(compare);
  }
end

function class:insert(k, v)
  local tree = self[private_tree]
  local h = tree:insert(k, v)
  return multimap_handle(tree, h)
end

function class:lower_bound(k)
  local tree = self[private_tree]
  local h = tree:lower_bound(k)
  if h == nil then
    return multimap_handle(tree)
  end
  return multimap_handle(tree, h, tree:maximum())
end

function class:upper_bound(k)
  local tree = self[private_tree]
  local h = tree:upper_bound(k)
  if h == nil then
    return multimap_handle(tree)
  end
  return multimap_handle(tree, tree:minimum(), h)
end

function class:equal_range(k)
  local tree = self[private_tree]
  local h = tree:search(k)
  if h == nil then
    return multimap_handle(tree)
  else
    return multimap_handle(tree, h, tree:upper_bound(k))
  end
end

function class:each()
  local tree = self[private_tree]
  local a = tree:minimum()
  if a == nil then
    return function () end
  else
    local b = tree:maximum()
    local that = multimap_handle(tree)
    return coroutine.wrap(function ()
      while true do
        local s = tree:successor(a)
        local k, v = tree:get(a)
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
  local tree = self[private_tree]
  return tree:empty()
end

function class:single()
  local tree = self[private_tree]
  return tree:single()
end

function class:head()
  local tree = self[private_tree]
  local h = tree:minimum()
  if h ~= nil then
    return tree:get(h)
  end
end

function class:tail()
  local tree = self[private_tree]
  local h = tree:maximum()
  if h ~= nil then
    return tree:get(h)
  end
end

class.metatable = {
  __index = class;
  __pairs = class.each;
}

return setmetatable(class, {
  __call = function (_, compare)
    return setmetatable(class.new(compare), class.metatable)
  end;
})
