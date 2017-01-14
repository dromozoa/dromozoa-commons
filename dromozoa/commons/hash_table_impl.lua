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

local equal = require "dromozoa.commons.equal"
local hash = require "dromozoa.commons.hash"
local pairs = require "dromozoa.commons.pairs"

local default_hasher = hash

local class = {}

function class.new(hasher)
  if hasher == nil then
    hasher = default_hasher
  end
  return {
    hasher = hasher;
    K = {}; -- key
    V = {}; -- value
    KS = {}; -- key set
    VS = {}; -- value set
  }
end

function class:get(key)
  local h = self.hasher(key)
  local K = self.K
  local k = K[h]
  if k == nil then
    return nil
  end
  if equal(k, key) then
    local V = self.V
    local v = V[h]
    return v
  end
  local KS = self.KS
  local ks = KS[h]
  if ks == nil then
    return nil
  end
  for i = 1, #ks do
    if equal(ks[i], key) then
      local VS = self.VS
      local vs = VS[h]
      local v = vs[i]
      return v
    end
  end
  return nil
end

function class:each()
  return coroutine.wrap(function ()
    local K = self.K
    local V = self.V
    for h, k in pairs(K) do
      coroutine.yield(k, V[h])
    end
    local KS = self.KS
    local VS = self.VS
    for h, ks in pairs(KS) do
      local vs = VS[h]
      for i = 1, #ks do
        coroutine.yield(ks[i], vs[i])
      end
    end
  end)
end

function class:insert(key, value, overwrite)
  local h = self.hasher(key)
  local K = self.K
  local k = K[h]
  if k == nil then
    local V = self.V
    K[h] = key
    V[h] = value
    return nil
  end
  if equal(k, key) then
    local V = self.V
    local v = V[h]
    if overwrite then
      V[h] = value
    end
    return v
  end
  local KS = self.KS
  local ks = KS[h]
  local VS = self.VS
  if ks == nil then
    KS[h] = { key }
    VS[h] = { value }
    return nil
  end
  local n = #ks
  for i = 1, n do
    if equal(ks[i], key) then
      local vs = VS[h]
      local v = vs[i]
      if overwrite then
        vs[i] = value
      end
      return v
    end
  end
  local vs = VS[h]
  n = n + 1
  ks[n] = key
  vs[n] = value
  return nil
end

function class:remove(key)
  local h = self.hasher(key)
  local K = self.K
  local k = K[h]
  if k == nil then
    return nil
  end
  local KS = self.KS
  local ks = KS[h]
  if equal(k, key) then
    local V = self.V
    local v = V[h]
    if ks == nil then
      K[h] = nil
      V[h] = nil
    else
      local VS = self.VS
      local vs = VS[h]
      K[h] = table.remove(ks, 1)
      V[h] = table.remove(vs, 1)
      if #ks == 0 then
        KS[h] = nil
        VS[h] = nil
      end
    end
    return v
  end
  for i = 1, #ks do
    if equal(ks[i], key) then
      table.remove(ks, i)
      local VS = self.VS
      local vs = VS[h]
      local v = table.remove(vs, i)
      if #ks == 0 then
        KS[h] = nil
        VS[h] = nil
      end
      return v
    end
  end
  return nil
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, hasher)
    return setmetatable(class.new(hasher), class.metatable)
  end;
})
