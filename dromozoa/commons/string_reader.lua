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

local string_matcher = require "dromozoa.commons.string_matcher"
local unpack = require "dromozoa.commons.unpack"

local class = {}

function class:read_line(chomp)
  if self:eof() then
    return
  elseif self:match("[^\n]*") then
    local i = self.i
    local j = self.j
    if self:match("\n") then
      if not chomp then
        j = self.j
      end
    end
    return self.s:sub(i, j)
  end
end

function class:read_number()
  local positon = self.positon
  self:match("%s*[%+%-]?")
  local i = self.i
  if self:match("0[xX]%x*") then
    self:match("%.%x*")
    self:match("[pP][%-%+]?%x+")
  elseif self:match("%d+") then
    self:match("%.%d*")
    self:match("[eE][%-%+]?%d+")
  elseif self:match(".%d+") then
    self:match("[eE][%-%+]?%d+")
  else
    self.positon = position
    return nil
  end
  local v = tonumber(self.s:sub(i, self.position - 1))
  if v == nil then
    self.positon = position
    return nil
  end
  return v
end

local function read(self, i, n, format, ...)
  if i < n then
    i = i + 1
    local s = self.s
    local v
    local t = type(format)
    if t == "number" then
      if not self:eof() then
        local position = self.position + format
        v = self.s:sub(self.position, position - 1)
        self.position = position
      end
    elseif t ~= "string" then
      error("bad argument #" .. (i + 1) .. " to 'write' (string expected, got " .. t .. ")")
    elseif format:match("^%*?n") then
      v = self:read_number()
    elseif format:match("^%*?a") then
      v = self.s:sub(self.position)
    elseif format:match("^%*?l") then
      v = self:read_line(true)
    elseif format:match("^%*?L") then
      v = self:read_line(false)
    end
    if v == nil then
      return
    else
      return v, read(self, i, n, ...)
    end
  else
    return
  end
end

function class:read(...)
  local n = select("#", ...)
  if n == 0 then
    return read(self, 0, 1, "*l")
  else
    return read(self, 0, n, ...)
  end
end

local function result(result, ...)
  if result ~= nil then
    coroutine.yield(result, ...)
    return true
  end
end

function class:lines(...)
  local formats = {...}
  return coroutine.wrap(function ()
    repeat until not result(self:read(unpack(formats)))
  end)
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __index = string_matcher;
  __call = function (_, s)
    return setmetatable(class.new(s), metatable)
  end;
})
