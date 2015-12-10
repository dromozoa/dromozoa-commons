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

local empty = require "dromozoa.commons.empty"
local pairs = require "dromozoa.commons.pairs"
local xml_escape = require "dromozoa.commons.xml_escape"

local function write(out, v)
  if type(v) == "string" then
    out:write(xml_escape(v))
  else
    local name = v[1]
    local attrs = v[2]
    local content = v[3]
    out:write("<", name)
    for name, value in pairs(attrs) do
      out:write(" ", name, "=\"", xml_escape(value), "\"")
    end
    if empty(content) then
      out:write("/>")
    else
      out:write(">")
      for node in content:each() do
        if type(node) == "string" then
          out:write(xml_escape(node))
        else
          write(out, node)
        end
      end
      out:write("</", name, ">")
    end
  end
  return out
end

return write
