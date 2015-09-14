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
local quote = require "dromozoa.commons.json.quote"

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

return write
