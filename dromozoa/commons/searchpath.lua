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

local lua_version_num = require "dromozoa.commons.lua_version_num"
local sequence_writer = require "dromozoa.commons.sequence_writer"

if lua_version_num >= 502 then
  return package.searchpath
else
  return function (name, path, sep, rep)
    if sep == nil then
      sep = "%."
    else
      sep = sep:gsub("%A", "%%%1")
    end
    if rep == nil then
      rep = "/"
    end
    if sep ~= "" then
      name = name:gsub(sep, rep)
    end
    local out = sequence_writer()
    for v in path:gmatch("[^%;]+") do
      local filename = v:gsub("%?", name)
      local handle = io.open(filename, "rb")
      if handle == nil then
        out:write("\n\tno file '", filename, "'")
      else
        handle:close()
        return filename
      end
    end
    return nil, out:concat()
  end
end
