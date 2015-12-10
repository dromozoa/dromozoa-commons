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

local sequence = require "dromozoa.commons.sequence"
local sequence_writer = require "dromozoa.commons.sequence_writer"
local string_matcher = require "dromozoa.commons.string_matcher"
local utf8 = require "dromozoa.commons.utf8"

local ws = "[ \t\r\n\f]*"
local class = {}

function class.new(this)
  if type(this) == "string" then
    this = string_matcher(this)
  end
  return {
    this = this;
    stack = sequence();
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

function class:selector_group()
  local this = self.this
  local stack = self.stack
  local that = sequence():push("selector_group")
  if self:selector() then
    that:push(stack:pop())
    while this:match("," .. ws) do
      if self:selector() then
        that:push(stack:pop())
      else
        self:raise("selector expected")
      end
    end
    return stack:push(that)
  else
    self:raise("selector expected")
  end
end

function class:selector()
  local this = self.this
  local stack = self.stack
  if self:simple_selector_sequence() then
    while true do
      local op
      if this:match(ws .. "([%+%>%~])" .. ws) then
        op = this[1]
      elseif this:match("[ \t\r\n\f]+") then
        op = "descendant"
      else
        return true
      end
      if self:simple_selector_sequence() then
        local b = stack:pop()
        local a = stack:pop()
        stack:push({ op, a, b })
      else
        self:raise()
      end
    end
  end
end

function class:simple_selector_sequence()
  local stack = self.stack
  local that = sequence():push("simple_selector_sequence")
  if self:type_selector() or self:universal() or self:hash() or self:class() or self:attrib() or self:pseudo() then
    that:push(stack:pop())
  else
    return
  end
  while self:hash() or self:class() or self:attrib() or self:pseudo() do
    that:push(stack:pop())
  end
  return stack:push(that)
end

function class:type_selector()
  local stack = self.stack
  if self:element_name() then
    return stack:push({ "type_selector", stack:pop() })
  end
end

function class:element_name()
  local stack = self.stack
  if self:ident() then
    return stack:push({ "element_name", stack:pop() })
  end
end

function class:universal()
  local this = self.this
  local stack = self.stack
  if this:match("%*") then
    return stack:push({ "*" })
  end
end

function class:class()
  local this = self.this
  local stack = self.stack
  if this:match("%.") then
    if self:ident() then
      return stack:push({ "class", stack:pop() })
    end
    self:raise()
  end
end

function class:attrib()
  local this = self.this
  local stack = self.stack
  if this:match("%[" .. ws) then
    if self:ident() then
      local op
      local a = stack:pop()
      local b
      if this:match(ws .. "([%^%$%*%~%|]?=)" .. ws) then
        op = this[1]
        if self:ident() or self:string() then
          b = stack:pop()
        else
          self:raise()
        end
      else
        op = "attrib"
      end
      if this:match(ws .. "%]") then
        return stack:push({ op, a, b })
      end
    end
    self:raise()
  end
end

function class:pseudo()
  local this = self.this
  local stack = self.stack
  if this:match(":") then
    if self:ident() and stack:pop():match("^[Nn][Oo][Tt]$") and this:match("%(" .. ws) then
      if self:type_selector() or self:universal() or self:hash() or self:class() or self:attrib() then
        if this:match(ws .. "%)") then
          return stack:push({ "not", stack:pop() })
        end
      end
    end
    self:raise("pseudo not implemented")
  end
end

function class:name_impl(start)
  local this = self.this
  local stack = self.stack
  if this:lookahead(start) or this:lookahead("\\[^\n\r\f]") then
    local out = sequence_writer()
    while true do
      if this:match("([%_A-Za-z%-\128-\255]+)") then
        out:write(this[1])
      elseif this:match("%\\(%x%x?%x?%x?%x?%x?)") then
        out:write(utf8.char(tonumber(this[1], 16)))
        if this:match("\r\n") or this:match("[ \n\r\t\f]") then
          -- ignore
        end
      elseif this:match("\\([^\n\r\f])") then
        out:write(this[1])
      else
        return stack:push(out:concat())
      end
    end
  end
end

function class:ident()
  return self:name_impl("%-?[%_A-Za-z\128-\255]")
end

function class:name()
  return self:name_impl("[%_A-Za-z%-\128-\255]")
end

function class:string()
  local this = self.this
  local stack = self.stack
  if this:match("([%\"%'])") then
    local quote = this[1]
    local out = sequence_writer()
    while not this:match(quote) do
      if this:match("([%\"%'])") then
        out:write(this[1])
      elseif this:match("([^\n\r\f%\\%\"%']+)") then
        out:write(this[1])
      elseif this:match("%\\\r\n") or this:match("%\\[\r\n]") then
        -- ignore
      elseif this:match("%\\(%x%x?%x?%x?%x?%x?)") then
        out:write(utf8.char(tonumber(this[1], 16)))
        if this:match("\r\n") or this:match("[ \n\r\t\f]") then
          -- ignore
        end
      elseif this:match("%\\([^\f])") then
        out:write(this[1])
      else
        self:raise()
      end
    end
    return stack:push(out:concat())
  end
end

function class:hash()
  local this = self.this
  local stack = self.stack
  if this:match("#") then
    if self:name() then
      return stack:push({ "#", stack:pop() })
    end
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
