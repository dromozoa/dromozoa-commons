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

local class = {}

function class.new()
  return { { [0] = 0 }, { [0] = 0 }, {}, {}, 0 }
end

function class:find(handle)
  local K = self[3]
  local V = self[4]
  local k = K[handle]
  local v = V[handle]
  return k, v
end

function class:get(handle)
  local V = self[4]
  local v = V[handle]
  return v
end

function class:empty()
  local P = self[1]
  return P[0] == 0
end

function class:each()
  return coroutine.wrap(function ()
    local N = self[2]
    local K = self[3]
    local V = self[4]
    local handle = N[0]
    while handle ~= 0 do
      coroutine.yield(K[handle], V[handle], handle)
      handle = N[handle]
    end
  end)
end

function class:set(handle, value)
  local V = self[4]
  local v = V[handle]
  V[handle] = value
  return v
end

function class:insert(key, value)
  local P = self[1]
  local N = self[2]
  local K = self[3]
  local V = self[4]
  local h = self[5] + 1
  local p = P[0]
  local n = N[p]
  P[h] = p
  N[h] = n
  K[h] = key
  V[h] = value
  P[n] = h
  N[p] = h
  self[5] = h
  return h
end

function class:remove(handle)
  local P = self[1]
  local N = self[2]
  local K = self[3]
  local V = self[4]
  local p = P[handle]
  local n = N[handle]
  local v = V[handle]
  P[handle] = nil
  N[handle] = nil
  K[handle] = nil
  V[handle] = nil
  P[n] = p
  N[p] = n
  return v
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
