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

local encoder_upper = {}
local encoder_lower = {}
local decoder = {}

local n = ("0"):byte()
for i = 0, 9 do
  local byte = i + n
  local char = string.char(byte)
  encoder_upper[i] = char
  encoder_lower[i] = char
  decoder[byte] = i
end

local n = ("A"):byte() - 10
for i = 10, 15 do
  local byte = i + n
  local char = string.char(byte)
  encoder_upper[i] = char
  decoder[byte] = i
end

local n = ("a"):byte() - 10
for i = 10, 15 do
  local byte = i + n
  local char = string.char(byte)
  encoder_lower[i] = char
  decoder[byte] = i
end

local function encode_impl(encoder, out, v)
  local b = v % 16
  local a = (v - b) / 16
  out:write(encoder[a], encoder[b])
end

local function encode(encoder, out, s, min, max)
  for i = min + 3, max, 4 do
    local a, b, c, d = s:byte(i - 3, i)
    encode_impl(encoder, out, a)
    encode_impl(encoder, out, b)
    encode_impl(encoder, out, c)
    encode_impl(encoder, out, d)
  end
  local i = max + 1
  local m = i - (i - min) % 4
  if m < i then
    local a, b, c = s:byte(m, max)
    if c then
      encode_impl(encoder, out, a)
      encode_impl(encoder, out, b)
      encode_impl(encoder, out, c)
    elseif b then
      encode_impl(encoder, out, a)
      encode_impl(encoder, out, b)
    else
      encode_impl(encoder, out, a)
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
    out:write(string.char(decoder[a] * 16 + decoder[b], decoder[c] * 16 + decoder[d]))
  end
  local i = max + 1
  local p = i - (i - min) % 4
  if p < i then
    if s:find("^%x%x", p) == nil then
      return nil, "decode error at position " .. p
    end
    local a, b, c = s:byte(p, max)
    if not c and b then
      out:write(string.char(decoder[a] * 16 + decoder[b]))
    else
      return nil, "decode error at position " .. p
    end
  end
  return out
end

local class = {}

function class.encode_upper(s, i, j)
  return encode(encoder_upper, sequence_writer(), s, translate_range(#s, i, j)):concat()
end

function class.encode_lower(s, i, j)
  return encode(encoder_lower, sequence_writer(), s, translate_range(#s, i, j)):concat()
end

function class.decode(s, i, j)
  local result, message = decode(sequence_writer(), s, translate_range(#s, i, j))
  if result == nil then
    return nil, message
  else
    return result:concat()
  end
end

class.encode = class.encode_upper

return class
