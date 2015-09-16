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

local ipairs = require "dromozoa.commons.ipairs"
local pairs = require "dromozoa.commons.pairs"
local sequence_writer = require "dromozoa.commons.sequence_writer"

local quote_char = {
  [string.char(0x22)] = [[\"]];
  [string.char(0x5C)] = [[\\]];
  [string.char(0x2F)] = [[\/]];
  [string.char(0x08)] = [[\b]];
  [string.char(0x0C)] = [[\f]];
  [string.char(0x0A)] = [[\n]];
  [string.char(0x0D)] = [[\r]];
  [string.char(0x09)] = [[\t]];
}

for i = 0x00, 0x19 do
  local char = string.char(i)
  if quote_char[char] == nil then
    quote_char[char] = string.format([[\u%04X]], i)
  end
end

local function quote(value)
  return "\"" .. value:gsub("[\"\\/%c]", quote_char) .. "\""
end

local function write(out, value)
  local t = type(value)
  if t == "number" then
    out:write(string.format("%.17g", value))
  elseif t == "string" then
    out:write(quote(value))
  elseif t == "boolean" then
    if value then
      out:write("true")
    else
      out:write("false")
    end
  elseif t == "table" then
    if value[1] == nil then
      out:write("{") local first = true
      for k, v in pairs(value) do
        if type(k) == "string" then
          if first then
            first = false
          else
            out:write(",")
          end
          out:write(quote(k), ":")
          write(out, v)
        end
      end
      out:write("}")
    else
      out:write("[")
      local first = true
      for _, v in ipairs(value) do
        if first then
          first = false
        else
          out:write(",")
        end
        write(out, v)
      end
      out:write("]")
    end
  else
    out:write("null")
  end
  return out
end

local function encode(value)
  return write(sequence_writer(), value):concat()
end

return {
  quote = quote;
  write = write;
  encode = encode;
}
