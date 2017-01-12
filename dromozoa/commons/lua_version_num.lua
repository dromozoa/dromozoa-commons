-- Copyright (C) 2015,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local major, minor = _VERSION:match("Lua (%d+)%.(%d+)$")
if major == nil then
  local loadstring = loadstring or load
  local chunk = string.dump(loadstring(""))
  if chunk:sub(1, 4) == "\27Lua" then
    local v = chunk:byte(5)
    minor = v % 16
    major = (v - minor) / 16
  elseif chunk:sub(1, 3) == "\27LJ" then
    error("unsupported chunk header (LuaJIT)")
  else
    error("unsupported chunk header")
  end
else
  major = tonumber(major)
  minor = tonumber(minor)
end

return major * 100 + minor
