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
local loadstring = require "dromozoa.commons.loadstring"
local pairs = require "dromozoa.commons.pairs"
local sequence_writer = require "dromozoa.commons.sequence_writer"

local function encode_key(key)
  local t = type(key)
  if t == "number" then
    return ("[%.17g]"):format(key)
  elseif t == "string" then
    if key:match("^[%a_][%w_]*$") then
      return key
    else
      return ("[%q]"):format(key)
    end
  elseif t == "boolean" then
    if key then
      return "[true]"
    else
      return "[false]"
    end
  end
end

local function write(out, value)
  local t = type(value)
  if t == "number" then
    out:write(("%.17g"):format(value))
  elseif t == "string" then
    out:write(("%q"):format(value))
  elseif t == "boolean" then
    if value then
      out:write("true")
    else
      out:write("false")
    end
  elseif t == "table" then
    out:write("{")
    if value[1] == nil then
      local first = true
      for k, v in pairs(value) do
        local k = encode_key(k)
        if k ~= nil then
          if first then
            first = false
          else
            out:write(",")
          end
          out:write(k, "=")
          write(out, v)
        end
      end
    else
      for i, v in ipairs(value) do
        if i > 1 then
          out:write(",")
        end
        write(out, v)
      end
    end
    out:write("}")
  else
    out:write("nil")
  end
  return out
end

local function encode(value)
  return write(sequence_writer(), value):concat()
end

local function decode(code)
  return assert(loadstring("return " .. code))()
end

return {
  write = write;
  encode = encode;
  decode = decode;
}
