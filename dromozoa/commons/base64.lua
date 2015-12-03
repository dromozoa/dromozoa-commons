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

local sequence_writer = require "dromozoa.commons.sequence_writer"
local translate_range = require "dromozoa.commons.translate_range"

local code_to_char = {
  [62] = "+";
  [63] = "/";
}

local n = ("A"):byte()
for i = 0, 25 do
  local byte = i + n
  local char = string.char(byte)
  code_to_char[i] = char
end

local n = ("a"):byte() - 26
for i = 26, 51 do
  local byte = i + n
  local char = string.char(byte)
  code_to_char[i] = char
end

local n = ("0"):byte() - 52
for i = 52, 61 do
  local byte = i + n
  local char = string.char(byte)
  code_to_char[i] = char
end

local class = {}

local function encode(s, i, j)
  local s = tostring(s)
  local min, max = translate_range(#s, i, j)
  local out = sequence_writer()
  for i = min + 2, max, 3 do
    local a, b, c = s:byte(i - 2, i)
    local a = a * 65536 + b * 256 + c
    local d = a % 64
    local a = (a - d) / 64
    local c = a % 64
    local a = (a - c) / 64
    local b = a % 64
    local a = (a - b) / 64
    out:write(code_to_char[a], code_to_char[b], code_to_char[c], code_to_char[d])
  end
  local i = max + 1
  local m = i - (i - min) % 3
  if m < i then
    local a, b = s:byte(m, max)
    if b then
      local a = a * 1024 + b * 4
      local c = a % 64
      local a = (a - c) / 64
      local b = a % 64
      local a = (a - b) / 64
      out:write(code_to_char[a], code_to_char[b], code_to_char[c], "=")
    else
      local a = a * 16
      local b = a % 64
      local a = (a - b) / 64
      out:write(code_to_char[a], code_to_char[b], "==")
    end
  end
  return out:concat()
end

return {
  encode = encode;
}
