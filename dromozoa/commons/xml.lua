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
local xml_escape = require "dromozoa.commons.xml_escape"
local xml_parser = require "dromozoa.commons.xml_parser"
local xml_selector = require "dromozoa.commons.xml_selector"
local xml_write = require "dromozoa.commons.xml_write"

local function parse(this)
  return xml_parser(this):apply()
end

local class = {
  escape = xml_escape;
  write = xml_write;
  parse = parse;
}

function class.encode(v)
  return xml_write(sequence_writer(), v):concat()
end

function class.decode(s)
  local v, matcher = parse(s)
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return v
end

function class.selector(s)
  return xml_selector.compile(s)
end

return class
