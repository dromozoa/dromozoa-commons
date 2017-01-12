-- Copyright (C) 2016,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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
    i = 1;
    size = 0;
  }
end

function class:write(s)
  local m = self.max + 1
  self[m] = s
  self.max = m
  self.size = self.size + #s
  return self
end

function class:close()
  self.eof = true
  return self
end

function class:find(char)
  local min = self.min
  local s = self[min]
  if s ~= nil then
    local i = self.i
    local p = s:find(char, i)
    if p == nil then
      p = #s - i + 1
      for m = min + 1, self.max do
        local s = self[m]
        local i = s:find(char, 1)
        if i == nil then
          p = p + #s
        else
          return p + i
        end
      end
    else
      return p - i + 1
    end
  end
end

function class:read(count)
  local min = self.min
  local max = self.max
  local s = self[min]
  local i = self.i
  local size = self.size
  if count < size then
    local j = i + count - 1
    local n = #s
    if j <= n then
      if j == n then
        j = 0
        s = s:sub(i)
        self[min] = nil
        self.min = min + 1
      else
        s = s:sub(i, j)
      end
      self.i = j + 1
      self.size = size - #s
      return s
    else
      if i > 1 then
        s = s:sub(i)
        self[min] = s
      end
      j = count - #s
      for m = min + 1, max do
        s = self[m]
        n = #s
        if j <= n then
          if j == n then
            j = 0
            s = table.concat(self, "", min, m)
          else
            m = m - 1
            s = table.concat(self, "", min, m) .. s:sub(1, j)
          end
          for m = min, m do
            self[m] = nil
          end
          self.min = m + 1
          self.i = j + 1
          self.size = size - #s
          return s
        else
          j = j - #s
        end
      end
    end
  elseif count == size or self.eof then
    local s = self[min]
    local i = self.i
    if i > 1 then
      self[min] = s:sub(i)
    end
    s = table.concat(self, "", min, max)
    for m = min, max do
      self[m] = nil
    end
    self.min = 1
    self.max = 0
    self.i = 1
    self.size = 0
    return s
  end
end

function class:read_line(sep)
  if sep == nil then
    sep = "\n"
  end
  local p = self:find(sep)
  if p == nil then
    if self.eof then
      return self:read(self.size)
    end
  else
    local line = self:read(p - 1)
    return line, self:read(1)
  end
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), class.metatable)
  end;
})
