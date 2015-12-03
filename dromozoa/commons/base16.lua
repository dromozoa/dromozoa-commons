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

local code_to_char = {}
local byte_to_code = {}

for i = 0, 9 do
  local byte = string.byte("0") + i
  local char = string.char(byte)
  code_to_char[i] = char
  byte_to_code[byte] = i
end
for i = 10, 15 do
  local byte = string.byte("A") + i - 10
  local char = string.char(byte)
  code_to_char[i] = char
  byte_to_code[byte] = i
  byte_to_code[char:lower():byte()] = i
end

local function encode_impl(out, v)
  local b = v % 16
  local a = (v - b) / 16
  out:write(code_to_char[a], code_to_char[b])
end

local function encode(out, s, min, max)
  for i = min + 3, max, 4 do
    local a, b, c, d = s:byte(i - 3, i)
    encode_impl(out, a)
    encode_impl(out, b)
    encode_impl(out, c)
    encode_impl(out, d)
  end
  local i = max + 1
  local m = i - (i - min) % 4
  if m < i then
    local a, b, c = s:byte(m, max)
    if c then
      encode_impl(out, a)
      encode_impl(out, b)
      encode_impl(out, c)
    elseif b then
      encode_impl(out, a)
      encode_impl(out, b)
    else
      encode_impl(out, a)
    end
  end
  return out
end

local function decode(out, s, min, max)
  for i = min + 3, max, 4 do
    local p = i - 3
    if s:find("^%x%x%x%x", p) == nil then
      return nil, "decode error at position " .. p
    end
    local a, b, c, d = s:byte(p, i)
    out:write(string.char(byte_to_code[a] * 16 + byte_to_code[b], byte_to_code[c] * 16 + byte_to_code[d]))
  end
  local i = max + 1
  local p = i - (i - min) % 4
  if p < i then
    if s:find("^%x%x", p) == nil then
      return nil, "decode error at position " .. p
    end
    local a, b, c = s:byte(p, max)
    if not c and b then
      out:write(string.char(byte_to_code[a] * 16 + byte_to_code[b]))
    else
      return nil, "decode error at position " .. p
    end
  end
  return out
end

return {
  encode = function (s, i, j)
    return encode(sequence_writer(), s, translate_range(#s, i, j)):concat()
  end;

  decode = function (s, i, j)
    local result, message = decode(sequence_writer(), s, translate_range(#s, i, j))
    if result == nil then
      return nil, message
    else
      return result:concat()
    end
  end;
}
