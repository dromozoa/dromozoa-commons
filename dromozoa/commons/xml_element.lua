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

local sequence_writer = require "dromozoa.commons.sequence_writer"
local xml_node_list = require "dromozoa.commons.xml_node_list"
local xml_write = require "dromozoa.commons.xml_write"

local class = {}

function class.new(name, attribute_list, content)
  return { name, attribute_list, content }
end

function class:name()
  return self[1]
end

function class:attr(name, value)
  return self[2][name]
end

function class:each()
  return self[3]:each()
end

function class:text()
  local out = sequence_writer()
  for node in self[3]:each() do
    if type(node) ~= "table" then
      xml_write(out, node)
    end
  end
  return out:concat()
end

function class:select(name)
  local result = xml_node_list()
  for node in self[3]:each() do
    if type(node) == "table" and node[1] == name then
      result:push(node)
    end
  end
  return result
end

local metatable = {
  __index = class;
}

function metatable:__tostring()
  return xml_write(sequence_writer(), self):concat()
end

return setmetatable(class, {
  __call = function (_, name, attribute_list, content)
    return setmetatable(class.new(name, attribute_list, content), metatable)
  end;
})
