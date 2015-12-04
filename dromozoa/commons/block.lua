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
    byte = { 0, 0, 0, 0 };
    -- ref, min, max
  }
end

function class:update_byte(s, min, max)
  local j = self.j
  local byte = self.byte

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

  if j == 4 then
    local byte = self.byte
    local a, b, c, d = byte[1], byte[2], byte[3], byte[4]
    local i = self.i + 1
    self[i] = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
    self.i = i
    self.j = 0
    return max + 1, false
  else
    self.j = j
    return max + 1, true
  end
end

function class:update_word(s, min, max)
  local _max = max
  local n = self.n
  local i = self.i
  local m = min + (n - i) * 4 - 1
  if max > m then
    max = m
  end
  local x = min
  for j = min + 3, max, 4 do
    local p = j - 3
    local a, b, c, d = s:byte(p, j)
    i = i + 1
    self[i] = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
    x = p + 4
  end
  self.i = i
  return x, self:is_full() or x > max
end

function class:update(s, i, j)
  local s = tostring(s)
  local min, max = translate_range(#s, i, j)
  local done

  if self:is_full() then
    self.i = 0
  end

  if self.j ~= 0 then
    min, done = self:update_byte(s, min, max)
    if done then
      return min
    end
  end

  min, done = self:update_word(s, min, max)
  if done then
    return min
  end

  return (self:update_byte(s, min, max))
end

function class:is_full()
  return self.i == self.n
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
