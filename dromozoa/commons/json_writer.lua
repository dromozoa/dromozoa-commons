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
local pairs = require "dromozoa.commons.pairs"

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
    if value[1] == nil then
      out:write("{")
      local first = true
      for k, v in pairs(value) do
        if type(k) == "string" then
          local k = encode_key(k)
          if k ~= nil then
            if first then
              first = false
            else
              out:write(",")
            end
            out:write(k, ":")
            self:write(v)
          end
        end
      end
      out:write("}")
    else
      out:write("[")
      local first = true
      for _, v in ipairs(value) do
        if first then
          first = false
        else
          out:write(",")
        end
        self:write(v)
      end
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
