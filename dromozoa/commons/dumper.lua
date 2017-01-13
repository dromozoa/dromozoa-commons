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

local dumper_writer = require "dromozoa.commons.dumper_writer"
local loadstring = require "dromozoa.commons.loadstring"
local sequence_writer = require "dromozoa.commons.sequence_writer"

local class = {}

function class.write(out, value, options)
  return dumper_writer(out, options):write(value)
end

function class.encode(value, options)
  return class.write(sequence_writer(), value, options):concat()
end

function class.decode(code)
  return assert(loadstring("return " .. code))()
end

return class
