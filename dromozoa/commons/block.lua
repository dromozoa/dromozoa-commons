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

local sequence = require "dromozoa.commons.sequence"
local translate_range = require "dromozoa.commons.translate_range"
local unpack = require "dromozoa.commons.unpack"

local class = {}

function class.new(n)
  local self = {
    i = 1;
  }
  for i = 1, n do
    self[i] = 0
  end
  return self
end

function class:update(s, i, j)
  local s = tostring(s)
  local min, max = translate_range(#s, i, j)

  local n = #self
  local j = self.i
  local m = min + n - j
  if max > m then
    max = m
  end

  for i = min + 3, max, 4 do
    local p = i - 3
    local a, b, c, d = s:byte(p, i)
    self[j] = a
    self[j + 1] = b
    self[j + 2] = c
    self[j + 3] = d
    j = j + 4
  end

  local i = max + 1
  local p = i - (i - min) % 4
  if p < i then
    local a, b, c = s:byte(p, max)
    if c then
      self[j] = a
      self[j + 1] = b
      self[j + 2] = c
      j = j + 3
    elseif b then
      self[j] = a
      self[j + 1] = b
      j = j + 2
    else
      self[j] = a
      j = j + 1
    end
  end

  if j > n then
    self.i = 1
  else
    self.i = j
  end

  return max + 1
end

function class:is_full()
  return self.i == 1
end

function class:word(i)
  local j = i * 4
  local a, b, c, d = self[j - 3], self[j - 2], self[j - 1], self[j]
  return a * 0x1000000+ b * 0x10000 + c * 0x100 + d
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, n)
    return setmetatable(class.new(n), metatable)
  end;
})
