-- Copyright (C) 2016 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local byte_buffer = require "dromozoa.commons.byte_buffer"
local dumper = require "dromozoa.commons.dumper"

local b = byte_buffer()
b:write("foo")
b:write("bar")
b:write("baz")
b:write("\n")
b:close()
-- print(json.encode(b))

print(b.max)
print(b.size)
print(b:find("z"))
print(b:find("\n"))
print("--")
print(dumper.encode(b))
print(b:read(4))
print(dumper.encode(b))
print(b:read(4))
print(b:read(4))

-- b:read(4)

