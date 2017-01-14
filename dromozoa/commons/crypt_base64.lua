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

local encoder = {
  [0] = ".";
  [1] = "/";
}

local n = ("0"):byte() - 2
for i = 2, 11 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
end

local n = ("A"):byte() - 12
for i = 12, 37 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
end

local n = ("a"):byte() - 38
for i = 38, 63 do
  local byte = i + n
  local char = string.char(byte)
  encoder[i] = char
end

local class = {}

function class.encode(out, s, i, j, k)
  if k then
    local a = s:byte(i)
    local b = s:byte(j)
    local c = s:byte(k)
    local d = a * 65536 + b * 256 + c
    local a = d % 64
    local d = (d - a) / 64
    local b = d % 64
    local d = (d - b) / 64
    local c = d % 64
    local d = (d - c) / 64
    out:write(encoder[a], encoder[b], encoder[c], encoder[d])
  elseif j then
    local a = s:byte(i)
    local b = s:byte(j)
    local c = a * 256 + b
    local a = c % 64
    local c = (c - a) / 64
    local b = c % 64
    local c = (c - b) / 64
    out:write(encoder[a], encoder[b], encoder[c])
  else
    local b = s:byte(i)
    local a = b % 64
    local b = (b - a) / 64
    out:write(encoder[a], encoder[b])
  end
  return out
end

return class
