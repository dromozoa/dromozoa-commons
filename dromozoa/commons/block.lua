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

  local m = #self - self.i + 1
  local n = max - min + 1
  if m > n then
    m = n
  end
  for i = min, min + m - 1 do
    self[self.i] = s:sub(i, i)
    self.i = self.i + 1
  end

  if self.i > #self then
    self.i = 1
  end

  return min + m
end

function class:is_full()
  return self.i == 1
end

function class:byte(i, j)
  return table.concat(self):byte(i, j)
end

function class:word(i)
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, n)
    return setmetatable(class.new(n), metatable)
  end;
})
