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
  [64] = "=";
  [65] = "==";
}

local decoder = {
  [("+"):byte()] = 62;
  [("/"):byte()] = 63;
}

local n = ("A"):byte()
for i = 0, 25 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
  decoder[byte] = i
end

local n = ("a"):byte() - 26
for i = 26, 51 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
  decoder[byte] = i
end

local n = ("0"):byte() - 52
for i = 52, 61 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
  decoder[byte] = i
end

local encoder_url = setmetatable({
  [62] = "-";
  [63] = "_";
  [64] = "";
  [65] = "";
}, { __index = encoder })

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
      out:write(encoder[a], encoder[b], encoder[c], encoder[64])
    else
      local a = a * 16
      local b = a % 64
      local a = (a - b) / 64
      out:write(encoder[a], encoder[b], encoder[65])
    end
  end

  return out
end

local function decode(out, s, min, max)
  local n = max - min + 1
  if n == 0 then
    return out
  elseif n % 4 ~= 0 then
    return nil, "length not divisible by 4"
  end

  for i = min + 3, max - 4, 4 do
    local p = i - 3
    if s:find("^[0-9A-Za-z%+%/][0-9A-Za-z%+%/][0-9A-Za-z%+%/][0-9A-Za-z%+%/]", p) == nil then
      return nil, "decode error at position " .. p
    end
    local a, b, c, d = s:byte(p, i)
    local a = decoder[a] * 262144 + decoder[b] * 4096 + decoder[c] * 64 + decoder[d]
    local c = a % 256
    local a = (a - c) / 256
    local b = a % 256
    local a = (a - b) / 256
    out:write(string.char(a, b, c))
  end

  local p = max - 3
  if s:find("^[0-9A-Za-z%+%/][0-9A-Za-z%+%/][0-9A-Za-z%+%/%=][0-9A-Za-z%+%/%=]", p) == nil then
    return nil, "decode error at position " .. p
  end
  local a, b, c, d = s:byte(p, max)
  local a = decoder[a]
  local b = decoder[b]
  local c = decoder[c]
  local d = decoder[d]
  if d == nil then
    if c == nil then
      if b % 16 ~= 0 then
        return nil, "decode error at position " .. p + 1
      end
      local a = a * 4 + b / 16
      out:write(string.char(a))
    else
      if c % 4 ~= 0 then
        return nil, "decode error at position " .. p + 2
      end
      local a = a * 1024 + b * 16 + c / 4
      local b = a % 256
      local a = (a - b) / 256
      out:write(string.char(a, b))
    end
  elseif c == nil then
    return nil, "decode error at position " .. p + 3
  else
    local a = a * 262144 + b * 4096 + c * 64 + d
    local c = a % 256
    local a = (a - c) / 256
    local b = a % 256
    local a = (a - b) / 256
    out:write(string.char(a, b, c))
  end

  return out
end

local class = {}

function class.encode(s, i, j)
  local s = tostring(s)
  return encode(encoder, sequence_writer(), s, translate_range(#s, i, j)):concat()
end

function class.encode_url(s, i, j)
  local s = tostring(s)
  return encode(encoder_url, sequence_writer(), s, translate_range(#s, i, j)):concat()
end

function class.decode(s, i, j)
  local s = tostring(s)
  local result, message = decode(sequence_writer(), s, translate_range(#s, i, j))
  if result == nil then
    return nil, message
  else
    return result:concat()
  end
end

return class
