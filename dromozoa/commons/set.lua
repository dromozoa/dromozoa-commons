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

local pairs = require "dromozoa.commons.pairs"

local class = {}

function class.includes(a, b)
  for k, v in pairs(b) do
    if a[k] == nil then
      return false
    end
  end
  return true
end

function class.intersection(a, b)
  local n = 0
  for k in pairs(a) do
    if b[k] == nil then
      n = n + 1
      a[k] = nil
    end
  end
  return n
end

function class.difference(a, b)
  local n = 0
  for k in pairs(a) do
    if b[k] ~= nil then
      n = n + 1
      a[k] = nil
    end
  end
  return n
end

function class.union(a, b)
  local n = 0
  for k, v in pairs(b) do
    if a[k] == nil then
      n = n + 1
      a[k] = v
    end
  end
  return n
end

function class.symmetric_difference(a, b)
  local n = 0
  for k, v in pairs(b) do
    n = n + 1
    if a[k] == nil then
      a[k] = v
    else
      a[k] = nil
    end
  end
  return n
end

return class
