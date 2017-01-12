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

local multimap = require "dromozoa.commons.multimap"

local super = multimap
local class = {}

function class:get(key)
  if key == nil then
    return nil
  end
  local handle = class.equal_range(self, key)
  if handle:empty() then
    return nil
  else
    local _, v = handle:head()
    return v
  end
end

function class:insert(key, value, overwrite)
  if key == nil then
    error "table index is nil"
  end
  if value == nil then
    value = true
  end
  local handle = class.equal_range(self, key)
  if handle:empty() then
    super.insert(self, key, value)
    return nil
  else
    local _, v = handle:head()
    if overwrite then
      handle:set(value)
    end
    return v
  end
end

function class:remove(key)
  if key == nil then
    error "table index is nil"
  end
  local handle = class.equal_range(self, key)
  if handle:empty() then
    return nil
  else
    local _, v = handle:head()
    handle:delete()
    return v
  end
end

function class:set(key, value)
  if value == nil then
    return class.remove(self, key)
  else
    return class.insert(self, key, value, true)
  end
end

class.metatable = {
  __newindex = class.set;
  __pairs = super.each;
}

function class.metatable:__index(key)
  local v = class.get(self, key)
  if v == nil then
    return class[key]
  else
    return v
  end
end

return setmetatable(class, {
  __index = super;
  __call = function (_, compare)
    return setmetatable(class.new(compare), class.metatable)
  end;
})
