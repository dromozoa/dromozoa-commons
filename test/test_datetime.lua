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
local equal = require "dromozoa.commons.equal"
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
assert(datetime.encode(result, offset) == "1979-10-19T12:00:00.001-04:00")

local result, offset = datetime.decode("8592-01-01T02:09+02:09")
assert(result.sec == nil)
assert(result.nsec == nil)
assert(offset == 7740)
assert(unix_time.encode(result, offset) == 208970150400)
assert(datetime.encode(result, offset) == "8592-01-01T02:09+02:09")

local result, offset = datetime.decode("12345-06-07 12:34:56.123456789-12:34")
assert(result.nsec == 123456789)
assert(unix_time.encode(result, offset) == 327417037736)
assert(datetime.encode(result, offset) == "12345-06-07T12:34:56.123456789-12:34")

assert(datetime.encode({ year = 2000, month = 1, day = 1 }) == "2000-01-01T12:00")
assert(datetime.encode({ year = 2000, month = 1, day = 1 }, 0) == "2000-01-01T12:00Z")
assert(datetime.encode({ year = 2000, month = 1, day = 1 }, 32400) == "2000-01-01T12:00+09:00")

local result, offset = datetime.decode("10/Oct/2000:13:55:36 -0700")
assert(equal(result, { year = 2000, month = 10, day = 10, hour = 13, min = 55, sec = 36 }))
assert(offset == -25200)
