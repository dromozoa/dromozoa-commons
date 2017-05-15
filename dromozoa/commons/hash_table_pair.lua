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

local class = {}

function class.new()
  return {
    P = {}; -- prev
    N = {}; -- next
    K = {}; -- key
    V = {}; -- value
    h = 0; -- handle
    f = nil; -- front
  }
end

function class:find(handle)
  local K = self.K
  local V = self.V
  local k = K[handle]
  local v = V[handle]
  return k, v
end

function class:get(handle)
  local V = self.V
  local v = V[handle]
  return v
end

function class:each()
  local f = self.f
  if f == nil then
    return function () end
  else
    local N = self.N
    local K = self.K
    local V = self.V
    return coroutine.wrap(function ()
      local handle = f
      repeat
        coroutine.yield(K[handle], V[handle], handle)
        handle = N[handle]
      until handle == f
    end)
  end
end

function class:set(handle, value)
  local V = self.V
  local v = V[handle]
  V[handle] = value
  return v
end

function class:insert(key, value)
  local P = self.P
  local N = self.N
  local K = self.K
  local V = self.V
  local h = self.h + 1
  local f = self.f
  if f == nil then
    P[h] = h
    N[h] = h
    self.f = h
  else
    local p = P[f]
    P[h] = p
    N[h] = f
    P[f] = h
    N[p] = h
  end
  K[h] = key
  V[h] = value
  self.h = h
  return h
end

function class:remove(handle)
  local P = self.P
  local N = self.N
  local K = self.K
  local V = self.V
  local p = P[handle]
  local n = N[handle]
  local v = V[handle]
  if handle == p then
    self.f = nil
  else
    if self.f == handle then
      self.f = n
    end
    P[n] = p
    N[p] = n
  end
  P[handle] = nil
  N[handle] = nil
  K[handle] = nil
  V[handle] = nil
  return v
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), class.metatable)
  end;
})
