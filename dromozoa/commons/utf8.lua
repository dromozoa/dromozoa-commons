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

local function decode(a)
  if a < 0 then
    return nil
  elseif a <= 0x7F then
    return string.char(a)
  elseif a <= 0x07FF then
    local b = a % 0x40
    local a = (a - b) / 0x40
    return string.char(a + 0xC0, b + 0x80)
  elseif a <= 0xFFFF then
    if 0xD800 <= a and a <= 0xDFFF then
      return nil
    end
    local c = a % 0x40
    local a = (a - c) / 0x40
    local b = a % 0x40
    local a = (a - b) / 0x40
    return string.char(a + 0xE0, b + 0x80, c + 0x80)
  elseif a <= 0x10FFFF then
    local d = a % 0x40
    local a = (a - d) / 0x40
    local c = a % 0x40
    local a = (a - c) / 0x40
    local b = a % 0x40
    local a = (a - b) / 0x40
    return string.char(a + 0xF0, b + 0x80, c + 0x80, d + 0x80)
  else
    return nil
  end
end

local function char(data, i, n, code, ...)
  if i < n then
    i = i + 1
    local value = decode(code)
    if value == nil then
      error("bad argument #" .. i .. " to 'char' (value out of range)")
    end
    data[i] = value
    return char(data, i, n, ...)
  else
    return data
  end
end

if _VERSION >= "Lua 5.3" then
  return {
    char = utf8.char;
  }
else
  return {
    char = function (...)
      return char(sequence(), 0, select("#", ...), ...):concat()
    end;
  }
end
