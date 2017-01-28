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

local datetime_parser = require "dromozoa.commons.datetime_parser"

local class = {}

function class.parse(this)
  return datetime_parser(this):parse()
end

function class.decode(code)
  local datetime, offset, matcher = class.parse(code)
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return datetime, offset
end

return class
