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

local RED = 0
local BLACK = 1
local NIL = 0

-- return an handle to the first element that is grater than key or equal to key.
local function lower_bound(T, x, key)
  local left = T.left
  local right = T.right
  local keys = T.keys
  local compare = T.compare

  local y = NIL
  while x ~= NIL do
    if compare(keys[x], key) then
      x = right[x]
    else
      y = x
      x = left[x]
    end
  end
  return y
end

-- return an handle to the last element that is less than key or equal to key.
local function upper_bound(T, x, key)
  local left = T.left
  local right = T.right
  local keys = T.keys
  local compare = T.compare

  local y = NIL
  while x ~= NIL do
    if compare(key, keys[x]) then
      x = left[x]
    else
      y = x
      x = right[x]
    end
  end
  return y
end

local function minimum(T, x)
  local left = T.left

  local lx = left[x]
  while lx ~= NIL do
    x = lx
    lx = left[x]
  end
  return x
end

local function maximum(T, x)
  local right = T.right

  local rx = right[x]
  while rx ~= NIL do
    x = rx
    rx = right[x]
  end
  return x
end

local function successor(T, x)
  local parent = T.parent
  local right = T.right

  local rx = right[x]
  if rx ~= NIL then
    return minimum(T, rx)
  end
  local y = parent[x]
  while y ~= NIL and x == right[y] do
    x = y
    y = parent[y]
  end
  return y
end

local function predecessor(T, x)
  local parent = T.parent
  local left = T.left

  local lx = left[x]
  if lx ~= NIL then
    return maximum(T, lx)
  end
  local y = parent[x]
  while y ~= NIL and x == left[y] do
    x = y
    y = parent[y]
  end
  return y
end

local function left_rotate(T, x)
  local parent = T.parent
  local left = T.left
  local right = T.right

  local y = right[x]
  local ly = left[y]
  right[x] = ly
  if ly ~= NIL then
    parent[ly] = x
  end
  local px = parent[x]
  parent[y] = px
  if px == NIL then
    T.root = y
  elseif x == left[px] then
    left[px] = y
  else
    right[px] = y
  end
  left[y] = x
  parent[x] = y
end

local function right_rotate(T, x)
  local parent = T.parent
  local left = T.left
  local right = T.right

  local y = left[x]
  local ry = right[y]
  left[x] = ry
  if ry ~= NIL then
    parent[ry] = x
  end
  local px = parent[x]
  parent[y] = px
  if px == NIL then
    T.root = y
  elseif x == right[px] then
    right[px] = y
  else
    left[px] = y
  end
  right[y] = x
  parent[x] = y
end

local function insert_fixup(T, z)
  local color = T.color
  local parent = T.parent
  local left = T.left
  local right = T.right

  local pz = parent[z]
  while color[pz] == RED do
    local ppz = parent[pz]
    if pz == left[ppz] then
      local y = right[ppz]
      if color[y] == RED then
        color[pz] = BLACK
        color[y] = BLACK
        color[ppz] = RED
        z = ppz
      else
        if z == right[pz] then
          z = pz
          left_rotate(T, z)
          pz = parent[z]
          ppz = parent[pz]
        end
        color[pz] = BLACK
        color[ppz] = RED
        right_rotate(T, ppz)
      end
    else
      local y = left[ppz]
      if color[y] == RED then
        color[pz] = BLACK
        color[y] = BLACK
        color[ppz] = RED
        z = ppz
      else
        if z == left[pz] then
          z = pz
          right_rotate(T, z)
          pz = parent[z]
          ppz = parent[pz]
        end
        color[pz] = BLACK
        color[ppz] = RED
        left_rotate(T, ppz)
      end
    end
    pz = parent[z]
  end
  color[T.root] = BLACK
end

local function insert(T, z)
  local color = T.color
  local parent = T.parent
  local left = T.left
  local right = T.right
  local keys = T.keys
  local compare = T.compare

  local kz = keys[z]

  local y = NIL
  local x = T.root
  while x ~= NIL do
    y = x
    if compare(kz, keys[x]) then
      x = left[x]
    else
      x = right[x]
    end
  end
  parent[z] = y
  if y == NIL then
    T.root = z
  elseif compare(kz, keys[y]) then
    left[y] = z
  else
    right[y] = z
  end
  left[z] = NIL
  right[z] = NIL
  color[z] = RED
  insert_fixup(T, z)
end

local function transplant(T, u, v)
  local parent = T.parent
  local left = T.left
  local right = T.right

  local pu = parent[u]

  if pu == NIL then
    T.root = v
  elseif u == left[pu] then
    left[pu] = v
  else
    right[pu] = v
  end
  parent[v] = pu
end

local function delete_fixup(T, x)
  local color = T.color
  local parent = T.parent
  local left = T.left
  local right = T.right

  while x ~= T.root and color[x] == BLACK do
    local px = parent[x]
    if x == left[px] then
      local w = right[px]
      if color[w] == RED then
        color[w] = BLACK
        color[px] = RED
        left_rotate(T, px)
        px = parent[x]
        w = right[px]
      end
      local lw = left[w]
      local rw = right[w]
      if color[lw] == BLACK and color[rw] == BLACK then
        color[w] = RED
        x = px
      else
        if color[rw] == BLACK then
          color[lw] = BLACK
          color[w] = RED
          right_rotate(T, w)
          px = parent[x]
          w = right[px]
          rw = right[w]
        end
        color[w] = color[px]
        color[px] = BLACK
        color[rw] = BLACK
        left_rotate(T, px)
        x = T.root
      end
    else
      local w = left[px]
      if color[w] == RED then
        color[w] = BLACK
        color[px] = RED
        right_rotate(T, px)
        w = left[px]
      end
      local lw = left[w]
      local rw = right[w]
      if color[rw] == BLACK and color[lw] == BLACK then
        color[w] = RED
        x = px
      else
        if color[lw] == BLACK then
          color[rw] = BLACK
          color[w] = RED
          left_rotate(T, w)
          px = parent[x]
          w = left[px]
          lw = left[w]
        end
        color[w] = color[px]
        color[px] = BLACK
        color[lw] = BLACK
        right_rotate(T, px)
        x = T.root
      end
    end
  end
  color[x] = BLACK
end

local function delete(T, z)
  local color = T.color
  local parent = T.parent
  local left = T.left
  local right = T.right
  local keys = T.keys

  local lz = left[z]
  local rz = right[z]

  local x
  local y = z
  local y_original_color = color[y]
  if lz == NIL then
    x = rz
    transplant(T, z, rz)
  elseif rz == NIL then
    x = lz
    transplant(T, z, lz)
  else
    y = minimum(T, rz)
    y_original_color = color[y]
    x = right[y]
    if parent[y] == z then
      parent[x] = y
    else
      transplant(T, y, x)
      rz = right[z]
      right[y] = rz
      parent[rz] = y
    end
    transplant(T, z, y)
    lz = left[z]
    left[y] = lz
    parent[lz] = y
    color[y] = color[z]
  end
  if y_original_color == BLACK then
    delete_fixup(T, x)
  end
end

local function default_compare(a, b)
  return a < b
end

local class = {}

function class.new(compare)
  if compare == nil then
    compare = default_compare
  end
  return {
    color = { [NIL] = BLACK };
    parent = { [NIL] = NIL };
    left = {};
    right = {};
    keys = {};
    values = {};
    compare = compare;
    root = NIL;
    handle = NIL;
  }
end

function class:lower_bound(key)
  local h = lower_bound(self, self.root, key)
  if h ~= NIL then
    return h
  end
end

function class:upper_bound(key)
  local h = upper_bound(self, self.root, key)
  if h ~= NIL then
    return h
  end
end

function class:upper_bound(key)
  local h = upper_bound(self, self.root, key)
  if h ~= NIL then
    return h
  end
end

function class:search(key)
  local keys = self.keys
  local compare = self.compare

  local h = lower_bound(self, self.root, key)
  if h ~= NIL and not compare(key, keys[h]) then
    return h
  end
end

function class:minimum()
  local h = self.root
  if h ~= NIL then
    return minimum(self, h)
  end
end

function class:maximum()
  local h = self.root
  if h ~= NIL then
    return maximum(self, h)
  end
end

function class:successor(h)
  h = successor(self, h)
  if h ~= NIL then
    return h
  end
end

function class:predecessor(h)
  h = predecessor(self, h)
  if h ~= NIL then
    return h
  end
end

function class:insert(key, value)
  local keys = self.keys
  local values = self.values

  local h = self.handle + 1
  keys[h] = key
  values[h] = value
  self.handle = h
  insert(self, h)
  return h
end

function class:delete(h)
  local color = self.color
  local parent = self.parent
  local left = self.left
  local right = self.right
  local keys = self.keys
  local values = self.values

  local key = keys[h]
  local value = values[h]
  delete(self, h)
  color[h] = nil
  parent[h] = nil
  left[h] = nil
  right[h] = nil
  keys[h] = nil
  values[h] = nil
  if self.root == NIL then
    self.handle = NIL
  end
  return key, value
end

function class:get(h)
  local keys = self.keys
  local values = self.values
  return keys[h], values[h]
end

function class:set(h, value)
  local values = self.values
  values[h] = value
end

function class:empty()
  return self.root == NIL
end

function class:single()
  local left = self.left
  local right = self.right
  local h = self.root
  return h ~= NIL and left[h] == NIL and right[h] == NIL
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, compare)
    return setmetatable(class.new(compare), class.metatable)
  end;
})
