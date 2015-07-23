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
  return { { 1 }, { 1 }, {}, {}, 1 }
end

function class:get(handle)
  local K = self[3]
  local V = self[4]
  local k = K[handle]
  local v = V[handle]
  return k, v
end

function class:front()
  return class.get(self, self[2][1])
end

function class:back()
  return class.get(self, self[1][1])
end

function class:empty()
  return self[1][1] == 1
end

function class:each()
  return coroutine.wrap(function ()
    local N = self[2]
    local K = self[3]
    local V = self[4]
    local handle = N[1]
    while handle ~= 1 do
      coroutine.yield(K[handle], V[handle])
      handle = N[handle]
    end
  end)
end

function class:insert(handle, key, value)
  local P = self[1]
  local N = self[2]
  local K = self[3]
  local V = self[4]
  local h = self[5] + 1
  local n = N[handle]
  P[h] = handle
  N[h] = n
  K[h] = key
  V[h] = value
  P[n] = h
  N[handle] = h
  self[5] = h
  return h
end

function class:push_front(key, value)
  return class.insert(self, 1, key, value)
end

function class:push_back(key, value)
  return class.insert(self, self[1][1], key, value)
end

function class:remove(handle)
  if handle == 1 then
    return nil, nil
  else
    local P = self[1]
    local N = self[2]
    local K = self[3]
    local V = self[4]
    local p = P[handle]
    local n = N[handle]
    local k = K[handle]
    local v = V[handle]
    P[handle] = nil
    N[handle] = nil
    K[handle] = nil
    V[handle] = nil
    P[n] = p
    N[p] = n
    return k, v
  end
end

function class:pop_front()
  return class.remove(self, self[2][1])
end

function class:pop_back()
  return class.remove(self, self[1][1])
end

return class
