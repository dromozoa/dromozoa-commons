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
    min = 1;
    max = 0;
    size = 0;
  }
end

function class:write(s)
  local n = self.max + 1
  self[n] = s
  self.max = n
  self.size = self.size + #s
  return self
end

function class:close()
  self.eof = true
  return self
end

function class:find(char)
  local n = self.min
  local s = self[n]
  local i = self.i or 1
  local p = s:find(char, i, true)
  if p == nil then
    p = #s - i + 1
    for n = n + 1, self.max do
      local s = self[n]
      local q = s:find(char, 1, true)
      if q == nil then
        p = p + #s
      else
        return p + q
      end
    end
    return nil
  else
    return p - i + 1
  end
end

function class:read(count)
  local size = self.size
  if count < size then
    local min = self.min
    local s = self[min]
    local i = self.i
    if i == nil then
      i = 1
    end
    local j = i + count - 1
    local n = #s
    if j <= n then
      if j == n then
        s = s:sub(i)
        self[min] = nil
        self.min = min + 1
        self.i = nil
      else
        s = s:sub(i, j)
        self.i = j + 1
      end
      self.size = size - #s
      return s
    else
      if i > 1 then
        s = s:sub(i)
      end
      j = j - #s
      self[min] = s
      for m = min + 1, self.max do
        local s = self[m]
        local n = #s
        if j <= n then
          if j == n then
            s = table.concat(self, "", min, m)
            for m = min, m do
              self[m] = nil
            end
            self.min = m + 1
            self.i = nil
          else
            local max = m - 1
            s = table.concat(self, "", min, max) .. s:sub(1, j)
            for m = min, max do
              self[m] = nil
            end
            self.min = m
            self.i = j + 1
          end
          self.size = size - #s
          return s
        else
          j = j - #s
        end
      end
    end
  elseif count == size or self.eof then
    local min = self.min
    local max = self.max
    local s = self[min]
    local i = self.i
    if i ~= nil then
      self[min] = s:sub(i)
    end
    s = table.concat(self, "", min, max)
    for m = min, max do
      self[m] = nil
    end
    self.i = nil
    self.min = 1
    self.max = 0
    self.size = 0
    return s
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
