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
local sequence_writer = require "dromozoa.commons.sequence_writer"
local xml_write = require "dromozoa.commons.xml_write"

local class = {}

function class:select(name)
  local result = class()
  for node in self:each() do
    result:copy(node:select(name))
  end
  return result
end

function class:text()
  local out = sequence_writer()
  for node in self:each() do
    out:write(node:text())
  end
  return out:concat()
end

local metatable = {
  __index = class;
}

function metatable:__tostring()
  local out = sequence_writer()
  for node in self:each() do
    xml_write(out, node)
  end
  return out:concat()
end

return setmetatable(class, {
  __index = sequence;
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
