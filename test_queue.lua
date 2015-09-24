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

local queue = require "dromozoa.commons.queue"

local q = queue()
assert(q:empty())
q:push()
assert(q:empty())
q:push(17)
q:push(23, 37)
assert(not q:empty())
assert(q:front() == 17)
assert(q:pop() == 17)
assert(q:pop() == 23)
assert(q:pop() == 37)
assert(q:empty())

local q = queue()
q:copy({})
q:copy({ 17 })
q:copy({ 23, 37 })
assert(not q:empty())
assert(q:front() == 17)
assert(q:pop() == 17)
assert(q:pop() == 23)
assert(q:pop() == 37)
assert(q:empty())

local q = queue():push(17, 23, 37, 42)
q:pop()
local m = 0
local n = 0
for v in q:each() do
  m = m + v
  n = n + 1
end
assert(m == 23 + 37 + 42)
assert(n == 3)
