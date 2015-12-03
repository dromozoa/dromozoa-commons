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

local encoder = {
  [62] = "+";
  [63] = "/";
}

local n = ("A"):byte()
for i = 0, 25 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
end

local n = ("a"):byte() - 26
for i = 26, 51 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
end

local n = ("0"):byte() - 52
for i = 52, 61 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
end

local function encode(encoder, out, s, min, max)
  for i = min + 2, max, 3 do
    local p = i - 2
    local a, b, c = s:byte(p, i)
    local a = a * 65536 + b * 256 + c
    local d = a % 64
    local a = (a - d) / 64
    local c = a % 64
    local a = (a - c) / 64
    local b = a % 64
    local a = (a - b) / 64
    out:write(encoder[a], encoder[b], encoder[c], encoder[d])
  end
  local i = max + 1
  local p = i - (i - min) % 3
  if p < i then
    local a, b = s:byte(p, max)
    if b then
      local a = a * 1024 + b * 4
      local c = a % 64
      local a = (a - c) / 64
      local b = a % 64
      local a = (a - b) / 64
      out:write(encoder[a], encoder[b], encoder[c], "=")
    else
      local a = a * 16
      local b = a % 64
      local a = (a - b) / 64
      out:write(encoder[a], encoder[b], "==")
    end
  end
  return out
end

local class = {}

function class.encode(s, i, j)
  local s = tostring(s)
  return encode(encoder, sequence_writer(), s, translate_range(#s, i, j)):concat()
end

return class
