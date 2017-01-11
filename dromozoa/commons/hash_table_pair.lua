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
  -- 1: P (prev)
  -- 2: N (next)
  -- 3: K (key)
  -- 4: V (value)
  -- 5: H (handle)
  -- 6: F (front)
  return { {}, {}, {}, {}, 0 }
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

function class:each()
  local F = self[6]
  if F == nil then
    return function () end
  else
    local N = self[2]
    local K = self[3]
    local V = self[4]
    return coroutine.wrap(function ()
      local handle = F
      repeat
        coroutine.yield(K[handle], V[handle], handle)
        handle = N[handle]
      until handle == F
    end)
  end
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
  local F = self[6]
  if F == nil then
    P[h] = h
    N[h] = h
    self[6] = h
  else
    local p = P[F]
    P[h] = p
    N[h] = F
    P[F] = h
    N[p] = h
  end
  K[h] = key
  V[h] = value
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
  if handle == p then
    self[6] = nil
  else
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
