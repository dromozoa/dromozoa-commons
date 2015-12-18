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

local class = {}

function class.new(this, endian)
  return {
    this = this;
    endian = endian;
  }
end

function class:read(...)
  return self.this:read(...)
end

function class:lines(...)
  return self.this:lines(...)
end

function class:seek(whence, offset)
  return self.this:seek(whence, offset)
end

function class:read_uint8(n)
  if n == nil or n < 2 then
    return self:read(1):byte()
  else
    return self:read(n):byte(1, n)
  end
end

function class:read_uint16(n)
  local a, b = self:read(2):byte(1, 2)
  local v
  if self.endian == ">" then
    v = a * 0x100 + b
  else
    v = b * 0x100 + a
  end
  if n == nil or n < 2 then
    return v
  else
    return v, self:read_uint16(n - 1)
  end
end

function class:read_uint32(n)
  local a, b, c, d = self:read(4):byte(1, 4)
  local v
  if self.endian == ">" then
    v = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
  else
    v = d * 0x1000000 + c * 0x10000 + b * 0x100 + a
  end
  if n == nil or n < 2 then
    return v
  else
    return v, self:read_uint32(n - 1)
  end
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, this, endian)
    return setmetatable(class.new(this, endian), metatable)
  end;
})
