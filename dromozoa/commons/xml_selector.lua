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
local split = require "dromozoa.commons.split"
local string_matcher = require "dromozoa.commons.string_matcher"
local utf8 = require "dromozoa.commons.utf8"

local function query(selector, stack)
  local top = stack:top()
  if selector(top, stack, #stack) then
    return top
  end
  for node in top:each() do
    if type(node) == "table" then
      stack:push(node)
      local result = query(selector, stack)
      stack:pop()
      if result ~= nil then
        return result
      end
    end
  end
end

local function query_all(selector, stack, result)
  local top = stack:top()
  if selector(top, stack, #stack) then
    result:push(top)
  end
  for node in top:each() do
    if type(node) == "table" then
      stack:push(node)
      query_all(selector, stack, result)
      stack:pop()
    end
  end
  return result
end

local ws = "[ \t\r\n\f]*"
local class = {
  query = query;
  query_all = query_all;
}

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

function class:push_noop()
  local stack = self.stack
  return stack:push(function () end)
end

function class:push_includes(a, b)
  local stack = self.stack
  if b:match("^[ \t\r\n\f]*$") then
    return self:push_noop()
  else
    return stack:push(function (top)
      local u = top:attr(a)
      if u ~= nil then
        for v in split(u, "[ \t\r\n\f]+"):each() do
          if v == b then
            return true
          end
        end
      end
    end)
  end
end

function class:selector_group()
  local this = self.this
  local stack = self.stack
  if self:selector() then
    while this:match("," .. ws) do
      if self:selector() then
        local b = stack:pop()
        local a = stack:pop()
        stack:push(function (...)
          return b(...) or a(...)
        end)
      else
        self:raise()
      end
    end
    return true
  else
    self:raise()
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
        -- descendant
      else
        return true
      end
      if self:simple_selector_sequence() then
        local b = stack:pop()
        local a = stack:pop()
        if op == nil then
          stack:push(function (top, stack, n)
            if n > 1 and b(top, stack, n) then
              for i = n - 1, 1, -1 do
                if a(stack[i], stack, i) then
                  return true
                end
              end
            end
          end)
        elseif op == ">" then
          stack:push(function (top, stack, n)
            if n > 1 and b(top, stack, n) then
              local i = n - 1
              return a(stack[i], stack, i)
            end
          end)
        else
          self:raise("not implemented")
        end
      else
        self:raise()
      end
    end
  end
end

function class:simple_selector_sequence()
  local stack = self.stack
  if self:type_selector() or self:universal() or self:hash() or self:class() or self:attrib() or self:pseudo() then
    while self:hash() or self:class() or self:attrib() or self:pseudo() do
      local b = stack:pop()
      local a = stack:pop()
      stack:push(function (...)
        return b(...) and a(...)
      end)
    end
    return true
  end
end

function class:type_selector()
  local stack = self.stack
  if self:element_name() then
    return true
  end
end

function class:element_name()
  local stack = self.stack
  if self:ident() then
    local a = stack:pop()
    return stack:push(function (top)
      return top:name() == a
    end)
  end
end

function class:universal()
  local this = self.this
  local stack = self.stack
  if this:match("%*") then
    return stack:push(function ()
      return true
    end)
  end
end

function class:class()
  local this = self.this
  local stack = self.stack
  if this:match("%.") then
    if self:ident() then
      return self:push_includes("class", stack:pop())
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
      end
      if this:match(ws .. "%]") then
        if op == nil then
          return stack:push(function (top)
            return top:attr(a) ~= nil
          end)
        elseif op == "=" then
          return stack:push(function (top)
            return top:attr(a) == b
          end)
        elseif op == "~=" then
          return self:push_includes(a, b)
        elseif op == "|=" then
          local c = "^" .. b:gsub("[^%a]", "%%%1") .. "%-?"
          return stack:push(function (top)
            local u = top:attr(a)
            return u ~= nil and u:find(c)
          end)
        elseif op == "^=" then
          if b == "" then
            return self:push_noop()
          else
            local c = "^" .. b:gsub("[^%a]", "%%%1")
            return stack:push(function (top)
              local u = top:attr(a)
              return u ~= nil and u:find(c)
            end)
          end
        elseif op == "$=" then
          if b == "" then
            return self:push_noop()
          else
            local c = b:gsub("[^%a]", "%%%1") .. "$"
            return stack:push(function (top)
              local u = top:attr(a)
              return u ~= nil and u:find(c)
            end)
          end
        elseif op == "*=" then
          if b == "" then
            return self:push_noop()
          else
            return stack:push(function (top)
              local u = top:attr(a)
              return u ~= nil and u:find(b, 1, true)
            end)
          end
        end
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
          local op = stack:pop()
          return stack:push(function (...)
            return not op(...)
          end)
        end
      end
    end
    self:raise("not implemented")
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
      local a = stack:pop()
      return stack:push(function (top)
        return top:attr("id") == a
      end)
    end
    self:raise()
  end
end

function class:apply()
  local this = self.this
  local stack = self.stack
  self:selector_group()
  if #stack == 1 then
    return stack:pop(), this
  else
    self:raise()
  end
end

function class.compile(s)
  local selector, matcher = class(s):apply()
  if not matcher:eof() then
    error("cannot reach eof at position " .. matcher.position)
  end
  return selector
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, this)
    return setmetatable(class.new(this), metatable)
  end;
})
