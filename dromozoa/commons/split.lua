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

local sequence = require "dromozoa.commons.sequence"

local function split(result, s, sep, n, i, j, k, ...)
  if j == nil then
    return result:push(s:sub(i))
  else
    if k < j then
      result:push(s:sub(i, i))
      i = i + 1
    else
      result:push(s:sub(i, j - 1))
      i = k + 1
    end
    result:push(...)
    if n < i then
      return result
    else
      return split(result, s, sep, n, i, s:find(sep, i))
    end
  end
end

return function (s, sep)
  return split(sequence(), s, sep, #s, 1, s:find(sep))
end
