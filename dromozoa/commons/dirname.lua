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

return function (path)
  -- step 1
  if path == "//" then
    return "//"
  -- step 2
  elseif path:find("^%/+$") then
    return "/"
  else
    -- step 3
    path = path:gsub("%/+$", "")
    -- step 4
    if path:find("^[^%/]*$") then
      return "."
    end
    -- step 5
    path = path:gsub("[^%/]+$", "")
    -- step 6
    if path == "//" then
      return "//"
    end
    -- step 7
    path = path:gsub("/+$", "")
    if path == "" then
      return "/"
    end
    return path
  end
end
