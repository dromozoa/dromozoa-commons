-- Copyright (C) 2015,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local json_parser = require "dromozoa.commons.json_parser"
local json_writer = require "dromozoa.commons.json_writer"
local sequence_writer = require "dromozoa.commons.sequence_writer"

local class = {
  quote = json_writer.quote;
  null = json_parser.null;
}

function class.write(out, value, options)
  return json_writer(out, options):write(value)
end

function class.encode(value, options)
  return class.write(sequence_writer(), value, options):concat()
end

function class.parse(this)
  return json_parser(this):parse()
end

function class.decode(code)
  local value, matcher = class.parse(code)
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return value
end

return class
