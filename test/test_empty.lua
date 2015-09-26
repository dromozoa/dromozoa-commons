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

local empty = require "dromozoa.commons.empty"
local hash_table = require "dromozoa.commons.hash_table"
local linked_hash_table = require "dromozoa.commons.linked_hash_table"
local queue = require "dromozoa.commons.queue"
local sequence = require "dromozoa.commons.sequence"

local t = linked_hash_table()
assert(empty(""))
assert(empty({}))
assert(empty(hash_table()))
assert(empty(linked_hash_table()))
assert(empty(queue()))
assert(empty(sequence()))
