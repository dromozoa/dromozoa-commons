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

local lua_version_num = require "dromozoa.commons.lua_version_num"
local sequence = require "dromozoa.commons.sequence"

local function decode(a)
  if a < 0 then
    return nil
  elseif a <= 0x7f then
    return string.char(a)
  elseif a <= 0x07ff then
    local b = a % 0x40
    local a = (a - b) / 0x40
    return string.char(a + 0xc0, b + 0x80)
  elseif a <= 0xffff then
    if 0xd800 <= a and a <= 0xdfff then
      return nil
    end
    local c = a % 0x40
    local a = (a - c) / 0x40
    local b = a % 0x40
    local a = (a - b) / 0x40
    return string.char(a + 0xe0, b + 0x80, c + 0x80)
  elseif a <= 0x10ffff then
    local d = a % 0x40
    local a = (a - d) / 0x40
    local c = a % 0x40
    local a = (a - c) / 0x40
    local b = a % 0x40
    local a = (a - b) / 0x40
    return string.char(a + 0xf0, b + 0x80, c + 0x80, d + 0x80)
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

if lua_version_num >= 503 then
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
