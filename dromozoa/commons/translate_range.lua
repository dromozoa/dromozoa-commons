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

return function (n, i, j)
  if i == nil then
    i = 1
  else
    if i < 0 then
      i = n + i + 1
    end
    if i < 1 then
      i = 1
    end
  end
  if j == nil then
    j = n
  else
    if j < 0 then
      j = n + j + 1
    end
    if j > n then
      j = n
    end
  end
  return i, j
end
