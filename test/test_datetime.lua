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

local datetime = require "dromozoa.commons.datetime"
local json = require "dromozoa.commons.json"
local unix_time = require "dromozoa.commons.unix_time"

local result, offset = datetime.decode("0037-12-13 00:00Z")
assert(result.year == 37)
assert(result.sec == nil)
assert(result.nsec == nil)
assert(offset == 0)

local result, offset = datetime.decode("1979-10-19T12:00:00.001-04:00")
assert(result.nsec == 1000000)
assert(offset == -14400)
assert(unix_time.encode(result, offset) == 309196800)

local result, offset = datetime.decode("8592-01-01T02:09+02:09")
assert(result.sec == nil)
assert(result.nsec == nil)
assert(offset == 7740)
assert(unix_time.encode(result, offset) == 208970150400)

local result, offset = datetime.decode("12345-06-07 12:34:56.123456789-12:34")
assert(result.nsec == 123456789)
assert(unix_time.encode(result, offset) == 327417037736)
