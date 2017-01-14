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

local class = {}

function class.new(tree, a, b)
  return class.reset({ tree = tree }, a, b)
end

function class:reset(a, b)
  if b == nil then
    b = a
  end
  self.a = a
  self.b = b
  return self
end

function class:remove()
  local a = self.a
  if a == nil then
    return 0
  else
    local tree = self.tree
    local b = self.b
    local n = 0
    while true do
      local s = tree:successor(a)
      tree:delete(a)
      n = n + 1
      if a == b then
        return n
      end
      a = s
    end
  end
end

function class:set(value)
  local a = self.a
  if a == nil then
    return 0
  else
    local tree = self.tree
    local b = self.b
    local n = 0
    while true do
      local s = tree:successor(a)
      tree:set(a, value)
      n = n + 1
      if a == b then
        return n
      end
      a = s
    end
  end
end

function class:each()
  local a = self.a
  if a == nil then
    return function () end
  else
    local tree = self.tree
    local b = self.b
    local that = class(tree)
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
  local a = self.a
  return a == nil
end

function class:single()
  local a = self.a
  return a ~= nil and a == self.b
end

function class:head()
  local a = self.a
  if a ~= nil then
    return self.tree:get(a)
  end
end

function class:tail()
  local b = self.b
  if b ~= nil then
    return self.tree:get(b)
  end
end

class.metatable = {
  __index = class;
  ["dromozoa.commons.is_stable"] = true;
}

function class.metatable:__pairs()
  local a = self.a
  if a == nil then
    return function () end
  else
    local tree = self.tree
    local b = self.b
    return coroutine.wrap(function ()
      while true do
        local s = tree:successor(a)
        local k, v = tree:get(a)
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
  __call = function (_, tree, a, b)
    return setmetatable(class.new(tree, a, b), class.metatable)
  end;
})
