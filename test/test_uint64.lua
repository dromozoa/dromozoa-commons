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

local equal = require "dromozoa.commons.equal"
local uint64 = require "dromozoa.commons.uint64"

local function test(this, that)
  assert(equal({ uint64.word(this) }, that))
  assert(equal({ uint64.word(this, "<") }, that))
  assert(equal({ uint64.word(this, ">") }, { that[2], that[1] }))
end

test(0xfeedface0000, { 0xface0000, 0x0000feed })
test(0xffffffffffff, { 0xffffffff, 0x0000ffff })
