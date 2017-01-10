-- Copyright (C) 2015-2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local function update_byte(self, s, min, max)
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
    if self.endian == ">" then
      self[i] = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
    else
      self[i] = d * 0x1000000 + c * 0x10000 + b * 0x100 + a
    end
    self.i = i
    self.j = 0
  else
    self.j = j
  end
  return max + 1
end

local function update_word(self, s, min, max)
  local n = self.n
  local i = self.i
  if i < n and min + 3 <= max then
    local endian = self.endian
    local m = min + (n - i) * 4 - 1
    if max > m then
      max = m
    end
    for j = min + 3, max, 4 do
      p = j - 3
      local a, b, c, d = s:byte(p, j)
      i = i + 1
      if endian == ">" then
        self[i] = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
      else
        self[i] = d * 0x1000000 + c * 0x10000 + b * 0x100 + a
      end
    end
    self.i = i
    return p + 4
  else
    return min
  end
end

local class = {}

function class.new(n, endian)
  return class.reset({
    n = n;
    endian = endian;
    i = 0;
    j = 0;
    byte = { 0, 0, 0, 0 };
  })
end

function class:reset()
  local n = self.n
  for i = 1, n do
    self[i] = 0
  end
  return self
end

function class:update(s, min, max)
  if min > max then
    return min
  end
  if self.i == self.n then
    self.i = 0
  end
  if self.j > 0 then
    min = update_byte(self, s, min, max)
  end
  if self.j == 0 then
    min = update_word(self, s, min, max)
    if self.i < self.n and min <= max then
      min = update_byte(self, s, min, max)
    end
  end
  return min
end

function class:full()
  return self.i == self.n
end

function class:flush()
  local n = self.n
  local i = self.i
  local j = self.j
  if j > 0 then
    local byte = self.byte
    for j = j + 1, 4 do
      byte[j] = 0
    end
    local a, b, c, d = byte[1], byte[2], byte[3], byte[4]
    i = i + 1
    if self.endian == ">" then
      self[i] = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
    else
      self[i] = d * 0x1000000 + c * 0x10000 + b * 0x100 + a
    end
    self.i = i
    self.j = 0
  end
  for i = i + 1, n do
    self[i] = 0
  end
  return i
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, n, endian)
    return setmetatable(class.new(n, endian), class.metatable)
  end;
})
