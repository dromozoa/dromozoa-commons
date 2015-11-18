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

local loadstring = require "dromozoa.commons.loadstring"
local pairs = require "dromozoa.commons.pairs"
local sequence_writer = require "dromozoa.commons.sequence_writer"

local function dump(value)
  local t = type(value)
  if t == "number" then
    return string.format("%.17g", value)
  elseif t == "string" then
    return string.format("%q", value)
  elseif t == "boolean" then
    if value then
      return "true"
    else
      return "false"
    end
  end
end

local function write(out, value)
  local v = dump(value)
  if v == nil then
    if type(value) == "table" then
      out:write("{")
      for k, v in pairs(value) do
        local k = dump(k)
        if k ~= nil then
          out:write("[", k, "]=")
          write(out, v)
          out:write(";")
        end
      end
      out:write("}")
    else
      out:write("nil")
    end
  else
    out:write(v)
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
