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

local shell = require "dromozoa.commons.shell"

assert(shell.quote("") == [['']])
assert(shell.quote("foo") == [['foo']])
assert(shell.quote("'foo") == [[\''foo']])
assert(shell.quote("''foo") == [[\'\''foo']])
assert(shell.quote("foo'") == [['foo'\']])
assert(shell.quote("foo''") == [['foo'\'\']])
assert(shell.quote("foo bar") == [['foo bar']])
assert(shell.quote("foo'bar") == [['foo'\''bar']])
assert(shell.quote("foo''bar") == [['foo'\'\''bar']])

assert(shell.exec() == true)
assert(shell.exec(":") == true)

local result, what, status = shell.exec("exit 42")
assert(result == nil)
assert(what == "exit")
assert(status == 42)

assert(shell.eval("echo foo") == "foo")
assert(shell.eval("cat", "foo\n") == "foo")
assert(shell.eval("cat | cat", "foo\n") == "foo")

local result, what, status = shell.eval("exit 42")
assert(result == nil)
assert(what == "exit")
assert(status == 42)

assert(shell.eval("echo " .. shell.quote("''foo''bar''")) == "''foo''bar''")
