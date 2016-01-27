-- Copyright (C) 2016 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local translate_range = require "dromozoa.commons.translate_range"

local class = {}

function class.new()
  return {
    S = {};
    I = {};
    J = {};
    min = 1;
    max = 0;
    size = 0;
    eof = false;
  }
end

function class:write(s, i, j)
  local i, j = translate_range(#s, i, j)
  local n = j - i + 1
  local max = self.max + 1
  local size = self.size + n
  self.S[max] = s
  self.I[max] = i
  self.J[max] = j
  self.max = max
  self.size = size
  return self
end

function class:close()
  self.eof = true
  return self
end

function class:find(char)
  local S = self.S
  local I = self.I
  local J = self.J
  local p = 0
  for m = self.min, self.max do
    local s = S[m]
    local i = I[m]
    local j = J[m]
    local n = j - i + 1
    local i = s:find(char, i, true)
    if i == nil then
      p = p + n
    else
      return p + i
    end
  end
  return nil
end

function class:read(count)
  assert(count > 0)
  local size = self.size
  if count <= size or self.eof then
    local result = ""
    local S = self.S
    local I = self.I
    local J = self.J
    local min = self.min
    while count > 0 do
      local s = S[min]
      if s == nil then
        break
      end
      local i = I[min]
      local j = J[min]
      local n = j - i + 1
      if count < n then
        local p = i + count
        result = result .. s:sub(i, p - 1)
        I[min] = p
        count = 0
        size = size - (p - i)
        break
      elseif count == n then
        result = result .. s:sub(i)
        S[min] = nil
        I[min] = nil
        J[min] = nil
        min = min + 1
        count = 0
        size = size - n
        break
      else
        result = result .. s:sub(i)
        S[min] = nil
        I[min] = nil
        J[min] = nil
        min = min + 1
        count = count - n
        size = size - n
      end
    end
    self.min = min
    self.size = size
    return result
  end
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
