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

local function insert(self, handle, key, value)
  local N = self[1]
  local P = self[2]
  local K = self[3]
  local V = self[4]
  local h = self[5] + 1
  local n = N[handle]
  N[h] = n
  P[h] = handle
  K[h] = key
  V[h] = value
  N[handle] = h
  P[n] = h
  self[5] = h
  return h
end

local class = {}

function class.new()
  return { { 1 }, { 1 }, {}, {}, 1 }
end

function class:get(handle)
  local V = self[4]
  local v = V[handle]
  return v
end

function class:empty()
  local N = self[1]
  return N[1] == 1
end

function class:each()
  return coroutine.wrap(function ()
    local N = self[1]
    local K = self[3]
    local V = self[4]
    local handle = N[1]
    while handle ~= 1 do
      coroutine.yield(K[handle], V[handle])
      handle = N[handle]
    end
  end)
end

function class:insert(key, value)
  local P = self[2]
  return insert(self, P[1], key, value)
end

function class:set(handle, value)
  local V = self[4]
  local v = V[handle]
  V[handle] = value
  return v
end

function class:remove(handle)
  local N = self[1]
  local P = self[2]
  local K = self[3]
  local V = self[4]
  local n = N[handle]
  local p = P[handle]
  local k = K[handle]
  local v = V[handle]
  N[handle] = nil
  P[handle] = nil
  K[handle] = nil
  V[handle] = nil
  N[p] = n
  P[n] = p
  return k, v
end

local metatable = {
  __index = class;
  __pairs = class.each;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
