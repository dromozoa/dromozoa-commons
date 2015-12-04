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
  return {
    n = n;
    i = 0;
    j = 0;
    b = { 0, 0, 0, 0 };
  }
end

function class:update_byte(s, min, max)
  local j = self.j
  if j == 0 then
    return min
  else
    local byte = self.b
    local m = min + 3 - j
    if max > m then
      max = m
    end
    local a, b, c = s:byte(min, max)
    if c then
      j = j + 3
      byte[j - 2] = a
      byte[j - 1] = b
      byte[j] = c
    elseif b then
      j = j + 2
      byte[j - 1] = a
      byte[j] = b
    else
      j = j + 1
      byte[j] = a
    end
    if j > 3 then
      self.j = 0
      local j = self.i + 1
      self[j] = byte[1] * 0x1000000 + byte[2] * 0x10000 + byte[3] * 0x100 + byte[4]
      self.i = j
    else
      self.j = j
    end
    return max + 1
  end
end

function class:update_word(s, min, max)
  local n = self.n
  local j = self.i
  local m = min + (n - j) * 4 - 1
  if max > m then
    max = m
  end
  local x = min
  for i = min + 3, max, 4 do
    local p = i - 3
    local a, b, c, d = s:byte(p, i)
    j = j + 1
    self[j] = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
    x = p + 4
  end
  if j >= n then
    self.i = 0
  else
    self.i = j
  end
  return x
end

function class:update_byte2(s, min, max)
  local n = max - min + 1
  if n <= 0 or n >= 4 then
    return min
  else
    assert(self.j == 0)
    local byte = self.b
    local a, b, c = s:byte(min, max)
    if c then
      byte[1] = a
      byte[2] = b
      byte[3] = c
      self.j = 3
      return min + 3
    elseif b then
      byte[1] = a
      byte[2] = b
      self.j = 2
      return min + 2
    else
      byte[1] = a
      self.j = 1
      return min + 1
    end
  end
end

function class:update(s, i, j)
  local s = tostring(s)
  local min, max = translate_range(#s, i, j)

  local min1 = min
  min = self:update_byte(s, min, max)
  min = self:update_word(s, min, max)
  if (not self:is_full()) or min1 == min then
    min = self:update_byte2(s, min, max)
  end
  return min
end

function class:is_full()
  return self.i == 0
end

function class:word(i)
  return self[i]
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, n)
    return setmetatable(class.new(n), metatable)
  end;
})
