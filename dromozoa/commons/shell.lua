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

local lua_version_num = require "dromozoa.commons.lua_version_num"
local read_file = require "dromozoa.commons.read_file"
local write_file = require "dromozoa.commons.write_file"

local q = [[']]
local e = [[\']]
local qeq = q .. e .. q
local eqq = e .. q .. q
local qqe = q .. q .. e

local class = {}

function class.quote(value)
  return ((q .. tostring(value):gsub(q, qeq) .. q):gsub(eqq, e):gsub(qqe, e))
end

if lua_version_num >= 502 then
  function class.exec(command)
    return os.execute(command)
  end

  function class.eval(command, stdin)
    if stdin == nil then
      local handle = assert(io.popen(command))
      local stdout = assert(handle:read("*a"))
      local result, what, status = handle:close()
      if result == nil then
        return nil, what, status
      else
        return (stdout:gsub("\n+", ""))
      end
    else
      local tmpin = os.tmpname()
      assert(write_file(tmpin, tostring(stdin)))
      local handle = assert(io.popen("(" .. command .. ")<" .. class.quote(tmpin)))
      local stdout = assert(handle:read("*a"))
      local result, what, status = handle:close()
      os.remove(tmpin)
      if result == nil then
        return nil, what, status
      else
        return (stdout:gsub("\n+", ""))
      end
    end
  end
else
  local function WTERMSIG(status)
    return status % 128
  end

  local function WIFSIGNALED(status)
    local v = WTERMSIG(status)
    return v ~= 0 and v ~= 127
  end

  local function WEXITSTATUS(status)
    local v = status / 256
    return (v - v % 1) % 256
  end

  local function WIFEXITED(status)
    return WTERMSIG(status) == 0
  end

  function class.exec(command)
    if command == nil then
      return os.execute() ~= 0
    else
      local status = os.execute(command)
      local what = "exit"
      if WIFEXITED(status) then
        status = WEXITSTATUS(status)
      elseif WIFSIGNALED(status) then
        what = "signal"
        status = WTERMSIG(status)
      end
      if what == "exit" and status == 0 then
        return true, what, status
      else
        return nil, what, status
      end
    end
  end

  function class.eval(command, stdin)
    if stdin == nil then
      local tmpout = os.tmpname()
      local result, what, status = class.exec("(" .. command .. ")>" .. class.quote(tmpout))
      local stdout = assert(read_file(tmpout))
      os.remove(tmpout)
      if result == nil then
        return nil, what, status
      else
        return (stdout:gsub("\n+", ""))
      end
    else
      local tmpin = os.tmpname()
      assert(write_file(tmpin, tostring(stdin)))
      local tmpout = os.tmpname()
      local result, what, status = class.exec("(" .. command .. ")<" .. class.quote(tmpin) .. ">" .. class.quote(tmpout))
      local stdout = assert(read_file(tmpout))
      os.remove(tmpin)
      os.remove(tmpout)
      if result == nil then
        return nil, what, status
      else
        return (stdout:gsub("\n+", ""))
      end
    end
  end
end

return class
