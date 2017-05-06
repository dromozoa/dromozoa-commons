-- Copyright (C) 2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local ipairs = require "dromozoa.commons.ipairs"
local is_array = require "dromozoa.commons.is_array"
local is_stable = require "dromozoa.commons.is_stable"
local pairs = require "dromozoa.commons.pairs"
local sequence = require "dromozoa.commons.sequence"

local quote_char = {
  [string.char(0x22)] = [[\"]];
  [string.char(0x5c)] = [[\\]];
  [string.char(0x2f)] = [[\/]];
  [string.char(0x08)] = [[\b]];
  [string.char(0x0c)] = [[\f]];
  [string.char(0x0a)] = [[\n]];
  [string.char(0x0d)] = [[\r]];
  [string.char(0x09)] = [[\t]];
}

for i = 0x00, 0x1f do
  local char = string.char(i)
  if quote_char[char] == nil then
    quote_char[char] = ([[\u%04X]]):format(i)
  end
end

local function quote(value)
  return "\"" .. tostring(value):gsub("[\"\\/%c]", quote_char) .. "\""
end

local function encode_key(key)
  local t = type(key)
  if t == "number" then
    return quote(("%.17g"):format(key))
  elseif t == "string" then
    return quote(key)
  elseif t == "boolean" then
    if key then
      return quote("true")
    else
      return quote("false")
    end
  end
end

local function pretty(self, value)
  if self.options.pretty then
    return value
  else
    return ""
  end
end

local function indent(self, depth)
  if self.options.pretty then
    local out = self.out
    out:write("\n")
    for _ = 1, depth do
      out:write("  ")
    end
  end
end

local class = {
  quote = quote;
}

function class.new(out, options)
  if options == nil then
    options = {}
  end
  return {
    out = out;
    options = options;
  }
end

function class:option(name, value)
  self.options[name] = value
  return self
end

function class:pretty(enabled)
  if enabled == nil then
    enabled = true
  end
  return self:option("pretty", enabled)
end

function class:stable(enabled)
  if enabled == nil then
    enabled = true
  end
  return self:option("stable", enabled)
end

function class:write(value, depth)
  if depth == nil then
    depth = 0
  end
  local out = self.out
  local t = type(value)
  if t == "number" then
    out:write(("%.17g"):format(value))
  elseif t == "string" then
    out:write(quote(value))
  elseif t == "boolean" then
    if value then
      out:write("true")
    else
      out:write("false")
    end
  elseif t == "table" then
    local n = is_array(value)
    if n == nil then
      local next_depth = depth + 1
      out:write("{")
      indent(self, next_depth)
      if self.options.stable and not is_stable(value) then
        local key_value_pairs = sequence()
        for k, v in pairs(value) do
          local k = encode_key(k)
          if k ~= nil then
            key_value_pairs:push({ k, v })
          end
        end
        key_value_pairs:sort(function (a, b)
          return a[1] < b[1]
        end)
        local first = true
        for key_value_pair in key_value_pairs:each() do
          if first then
            first = false
          else
            out:write(",")
            indent(self, next_depth)
          end
          out:write(key_value_pair[1], ":", pretty(self, " "))
          self:write(key_value_pair[2], next_depth)
        end
      else
        local first = true
        for k, v in pairs(value) do
          local k = encode_key(k)
          if k ~= nil then
            if first then
              first = false
            else
              out:write(",")
              indent(self, next_depth)
            end
            out:write(k, ":", pretty(self, " "))
            self:write(v, next_depth)
          end
        end
      end
      indent(self, depth)
      out:write("}")
    elseif n == 0 then
      if getmetatable(value) == sequence.metatable then
        out:write("[]")
      else
        out:write("{}")
      end
    else
      local next_depth = depth + 1
      out:write("[")
      indent(self, next_depth)
      for i = 1, n do
        if i > 1 then
          out:write(",")
          indent(self, next_depth)
        end
        self:write(value[i], next_depth)
      end
      indent(self, depth)
      out:write("]")
    end
  else
    out:write("null")
  end
  return out
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, out, options)
    return setmetatable(class.new(out, options), class.metatable)
  end;
})
