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
local pairs = require "dromozoa.commons.pairs"

local function encode_key(key)
  local t = type(key)
  if t == "number" then
    return ("[%.17g]"):format(key)
  elseif t == "string" then
    if key:find("^[%a_][%w_]*$") then
      return key
    else
      return ("[%q]"):format(key)
    end
  elseif t == "boolean" then
    if key then
      return "[true]"
    else
      return "[false]"
    end
  end
end

local function pretty_space(self)
  if self.options.pretty then
    self.out:write(" ")
  end
end

local function pretty_newline(self, depth)
  if self.options.pretty then
    local out = self.out
    out:write("\n")
    for _ = 1, depth do
      out:write("  ")
    end
  end
end

local class = {}

function class.new(out)
  return {
    out = out;
    options = {};
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
    out:write(("%q"):format(value))
  elseif t == "boolean" then
    if value then
      out:write("true")
    else
      out:write("false")
    end
  elseif t == "table" then
    local n = is_array(value)
    if n == nil then
      out:write("{")
      pretty_newline(self, depth + 1)
      local first = true
      for k, v in pairs(value) do
        local k = encode_key(k)
        if k ~= nil then
          if first then
            first = false
          else
            out:write(",")
            pretty_newline(self, depth + 1)
          end
          out:write(k)
          pretty_space(self, " ")
          out:write("=")
          pretty_space(self, " ")
          self:write(v, depth + 1)
        end
      end
      pretty_newline(self, depth)
      out:write("}")
    elseif n == 0 then
      out:write("{}")
    elseif n == 1 then
      out:write("{")
      pretty_space(self, " ")
      self:write(value[1])
      pretty_space(self, " ")
      out:write("}")
    else
      out:write("{")
      pretty_newline(self, depth + 1)
      for i = 1, n do
        if i > 1 then
          out:write(",")
          pretty_newline(self, depth + 1)
        end
        self:write(value[i], depth + 1)
      end
      pretty_newline(self, depth)
      out:write("}")
    end
  else
    out:write("nil")
  end
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, out)
    return setmetatable(class.new(out), class.metatable)
  end;
})
