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
  local m = min + n - self.i
  if m > max then
    m = max
  end

  local j = self.i
  for i = min, m do
    self[j] = s:byte(i, i)
    j = j + 1
  end

  if j > n then
    self.i = 1
  else
    self.i = j
  end

  return m + 1
end

function class:is_full()
  return self.i == 1
end

function class:byte(i, j)
  local min, max = translate_range(#self, i, j, true)
  if min == max then
    return self[min]
  else
    return unpack(self, min, max)
  end
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
