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

local class = {}

function class.new(name, attribute_list, content)
  return { name, attribute_list, content }
end

function class:attr(name, value)
  if value == nil then
    return self[2][name]
  else
    self[2][name] = value
    return self
  end
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, name, attribute_list, content)
    return setmetatable(class.new(name, attribute_list, content), metatable)
  end;
})
