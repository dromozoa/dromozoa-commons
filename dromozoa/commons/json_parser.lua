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

local matcher = require "dromozoa.commons.matcher"
local sequence = require "dromozoa.commons.sequence"
local sequence_writer = require "dromozoa.commons.sequence_writer"
local linked_hash_table = require "dromozoa.commons.sequence"
local utf8 = require "dromozoa.commons.utf8"

local null = function () end

local class = {}

function class.new(this)
  if type(this) == "string" then
    this = matcher(this)
  end
  return {
    this = this;
    stack = sequence()
  }
end

function class:raise(message)
  local this = self.this
  if message == nil then
    error("parse error at position " .. this.position)
  else
    error(message .. " at position " .. this.position)
  end
end

function class:parse_object()
  local this = self.this
  local stack = self.stack
  local object = linked_hash_table()
  local n = 0
  local first = true
  while true do
    this:match("[ \t\n\r]*")
    if not this:match("\"") then
      self:raise()
    end
    self:parse_string()
    local key = stack:pop()
    this:match("[ \t\n\r]*")
    if not this:match(":") then
      self:raise()
    end
    self:parse_value()
    object[key] = stack:pop()
    this:match("[ \t\n\r]*")
    if this:match("%}") then
      stack:push(object)
      return
    elseif not this:match("%,") then
      self:raise()
    end
  end
end

function class:parse_array()
  local this = self.this
  local stack = self.stack
  local array = sequence()
  local n = 0
  local first = true
  while true do
    this:match("[ \t\n\r]*")
    self:parse_value()
    array:push(stack:pop())
    this:match("[ \t\n\r]*")
    if this:match("%]") then
      stack:push(array)
      return
    elseif not this:match("%,") then
      self:raise()
    end
  end
end

local parse_char = {
  ["\""] = "\"";
  ["\\"] = "\\";
  ["/"] = "/";
  ["b"] = "\b";
  ["f"] = "\f";
  ["n"] = "\n";
  ["r"] = "\r";
  ["t"] = "\t";
}

function class:parse_string()
  local this = self.this
  local stack = self.stack
  local out = sequence_writer()
  while true do
    if this:match([["]]) then
      stack:push(out:concat())
      return
    elseif this:match([[([^%\%"]+)]]) then
      out:write(this[1])
    elseif this:match([[\([%"%\%/bfnrt])]]) then
      out:write(parse_char[this[1]])
    elseif this:match([[\u([Dd][89ABab]%x%x)\u([Dd][C-Fc-f]%x%x)]]) then
      local a = tonumber(this[1], 16) % 0x0400 * 0x0400
      local b = tonumber(this[2], 16) % 0x0400
      out:write(utf8.char(a + b + 0x010000))
    elseif this:match([[\u(%x%x%x%x)]]) then
      out:write(utf8.char(tonumber(this[1], 16)))
    else
      self:raise()
    end
  end
end

function class:parse_value()
  local this = self.this
  local stack = self.stack
  this:match("[ \t\n\r]*")
  if this:match("false") then
    stack:push(false)
  elseif this:match("null") then
    stack:push(null)
  elseif this:match("true") then
    stack:push(true)
  elseif this:match("%{") then
    self:parse_object()
  elseif this:match("%[") then
    self:parse_array()
  elseif this:match("%-?0") or this:match("%-?[1-9]%d*") then
    local i = this.i
    local j = this.j
    if this:match("%.%d+") then
      j = this.j
    end
    if this:match("[eE][%+%-]?%d+") then
      j = this.j
    end
    stack:push(tonumber(this.s:sub(i, j)))
  elseif this:match("\"") then
    self:parse_string()
  else
    self:raise()
  end
end

function class:apply()
  local stack = self.stack
  self:parse_value()
  if #stack == 1 then
    return stack:pop(), self.this
  else
    self:raise()
  end
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, this)
    return setmetatable(class.new(this), metatable)
  end;
})
