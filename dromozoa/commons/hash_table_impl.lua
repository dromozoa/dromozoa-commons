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
local murmur_hash3 = require "dromozoa.commons.murmur_hash3"
local pairs = require "dromozoa.commons.pairs"

local function hash(key)
  local t = type(key)
  if t == "number" then
    return murmur_hash3.double(key, 1)
  elseif t == "string" then
    return murmur_hash3.string(key, 2)
  elseif t == "boolean" then
    if key then
      return murmur_hash3.uint32(1, 3)
    else
      return murmur_hash3.uint32(0, 3)
    end
  elseif t == "table" then
    local h = murmur_hash3.uint64(#key, 4)
    for i = 1, #key do
      h = murmur_hash3.uint32(hash(key[i]), h)
    end
    return h
  else
    return 0
  end
end

local class = {}

function class.new()
  -- 1: K
  -- 2: V
  -- 3: KS
  -- 4: VS
  return { {}, {}, {}, {} }
end

function class:get(key)
  local h = hash(key)
  local K = self[1]
  local k = K[h]
  if k == nil then
    return nil
  end
  if equal(k, key) then
    local V = self[2]
    local v = V[h]
    return v
  end
  local KS = self[3]
  local ks = KS[h]
  if ks == nil then
    return nil
  end
  for i = 1, #ks do
    if equal(ks[i], key) then
      local VS = self[4]
      local vs = VS[h]
      local v = vs[i]
      return v
    end
  end
  return nil
end

function class:each()
  return coroutine.wrap(function ()
    local K = self[1]
    local V = self[2]
    for h, k in pairs(K) do
      coroutine.yield(k, V[h])
    end
    local KS = self[3]
    local VS = self[4]
    for h, ks in pairs(KS) do
      local vs = VS[h]
      for i = 1, #ks do
        coroutine.yield(ks[i], vs[i])
      end
    end
  end)
end

function class:insert(key, value, overwrite)
  local h = hash(key)
  local K = self[1]
  local k = K[h]
  if k == nil then
    local V = self[2]
    K[h] = key
    V[h] = value
    return nil
  end
  if equal(k, key) then
    local V = self[2]
    local v = V[h]
    if overwrite then
      V[h] = value
    end
    return v
  end
  local KS = self[3]
  local ks = KS[h]
  if ks == nil then
    local VS = self[4]
    KS[h] = { key }
    VS[h] = { value }
    return nil
  end
  local n = #ks
  for i = 1, n do
    if equal(ks[i], key) then
      local VS = self[4]
      local vs = VS[h]
      local v = vs[i]
      if overwrite then
        vs[i] = value
      end
      return v
    end
  end
  local VS = self[4]
  local vs = VS[h]
  n = n + 1
  ks[n] = key
  vs[n] = value
  return nil
end

function class:remove(key)
  local h = hash(key)
  local K = self[1]
  local k = K[h]
  if k == nil then
    return nil
  end
  local KS = self[3]
  local ks = KS[h]
  if equal(k, key) then
    local V = self[2]
    local v = V[h]
    if ks == nil then
      K[h] = nil
      V[h] = nil
    else
      local VS = self[4]
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
      local VS = self[4]
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
  __call = function ()
    return setmetatable(class.new(), class.metatable)
  end;
})
