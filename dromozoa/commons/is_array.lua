-- Copyright (C) 2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

return function (self)
  if type(self) == "table" then
    local m = 0
    local n = 0
    for k in pairs(self) do
      if type(k) == "number" and k > 0 and k % 1 == 0 then
        if m < k then
          m = k
        end
        n = n + 1
      else
        return
      end
    end
    if n * 1.8 < m then
      return
    end
    return m
  end
end
