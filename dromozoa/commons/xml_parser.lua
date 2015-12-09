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
local linked_hash_table = require "dromozoa.commons.linked_hash_table"
local string_matcher = require "dromozoa.commons.string_matcher"
local sequence = require "dromozoa.commons.sequence"
local sequence_writer = require "dromozoa.commons.sequence_writer"
local utf8 = require "dromozoa.commons.utf8"

local zero_width_no_break_space = string.char(0xef, 0xbb, 0xbf)

local class = {}

local metatable = {
  __index = class;
}

function class.new(this)
  if type(this) == "string" then
    this = string_matcher(this)
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

function class:document()
  local this = self.this
  local stack = self.stack
  this:match(zero_width_no_break_space)
  repeat
    this:match("%s*")
  until not self:comment()
  if not self:element() then
    self:raise()
  end
  repeat
    this:match("%s*")
  until not self:comment()
end

function class:element()
  local this = self.this
  local stack = self.stack
  if this:match("<([A-Za-z%_\128-\255][A-Za-z%_0-9%-%.\128-\255]*)") then
    local name = this[1]
    self:attribute_list()
    local attrbute_list = stack:pop()
    this:match("%s*")
    if this:match(">") then
      stack:push({ name, attrbute_list })
      self:content()
      return true
    elseif this:match("/>") then
      stack:push({ name, attrbute_list, sequence() })
      return true
    end
  end
end

function class:content()
  local this = self.this
  local stack = self.stack
  local that = sequence()
  while true do
    if this:match("</([A-Za-z%_\128-\255][A-Za-z%_0-9%-%.\128-\255]*)") then
      local name = this[1]
      if this:match("%s*>") then
        local tag = stack:top()
        if tag[1] == name and tag[3] == nil then
          tag[3] = that
          return true
        end
      end
      self:raise()
    elseif self:comment() then
      -- noop
    elseif self:element() then
      that:push(stack:pop())
    else
      local out = sequence_writer()
      while true do
        if this:match("\r\n") or this:match("\r") then
          out:write("\n")
        elseif this:match([[([^%<%>%&]+)]]) then
          out:write(this[1])
        elseif self:char_ref() then
          out:write(stack:pop())
        elseif self:comment() then
          -- noop
        elseif this:lookahead("<") then
          break
        else
          self:raise()
        end
      end
      if empty(out) then
        -- break
      else
        that:push(out:concat())
      end
    end
  end
end

function class:attribute_list()
  local this = self.this
  local stack = self.stack
  local that = linked_hash_table()
  while true do
    if not this:match("%s*([A-Za-z%_\128-\255][A-Za-z%_0-9%-%.\128-\255]*)") then
      break
    end
    local name = this[1]
    -- assert(name ~= "xmlns")
    if not this:match("%s*%=%s*") then
      self:raise()
    end
    if this:match([[([%"%'])]]) then
      self:attribute_value(this[1])
      local value = stack:pop()
      that[name] = value
    else
      self:raise()
    end
  end
  stack:push(that)
end

function class:attribute_value(quote)
  local this = self.this
  local stack = self.stack
  local out = sequence_writer()
  while true do
    if this:match(quote) then
      stack:push(out:concat())
      return true
    elseif this:match("\r\n") or this:match("\r") then
      out:write("\n")
    elseif this:match("([^%<%>%&%\"%'\r\n]+)") or this:match("([%\"%'\n])") then
      out:write(this[1])
    elseif self:char_ref() then
      out:write(stack:pop())
    else
      self:raise()
    end
  end
end

function class:comment()
  local this = self.this
  if this:match("%<!%-%-") then
    while true do
      if this:match("%-%-%>") then
        return true
      elseif not this:match("[^%-]") and not this:match("%-[^%-]") then
        self:raise()
      end
    end
  end
end

function class:char_ref()
  local this = self.this
  local stack = self.stack
  if this:match([[%&%#x(%x+)%;]]) then
    return stack:push(utf8.char(tonumber(this[1], 16)))
  elseif this:match([[%&amp%;]]) then
    return stack:push([[&]])
  elseif this:match([[%&lt%;]]) then
    return stack:push([[<]])
  elseif this:match([[%&gt%;]]) then
    return stack:push([[>]])
  elseif this:match([[%&quot%;]]) then
    return stack:push([["]])
  elseif this:match([[%&apos%;]]) then
    return stack:push([[']])
  end
end

function class:apply()
  local this = self.this
  local stack = self.stack
  self:document()
  if #stack == 1 then
    return stack:pop(), self.this
  else
    self:raise()
  end
end

return setmetatable(class, {
  __call = function (_, this)
    return setmetatable(class.new(this), metatable)
  end;
})
