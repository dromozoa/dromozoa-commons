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

local char_refs = {
  [string.char(0x26)] = "&amp;";
  [string.char(0x3c)] = "&lt;";
  [string.char(0x3e)] = "&gt;";
  [string.char(0x22)] = "&quot;";
  [string.char(0x27)] = "&apos;";
}

for byte = 0, 127 do
  local char = string.char(byte)
  if char_refs[char] == nil then
    char_refs[char] = ("&#x%x;"):format(byte)
  end
end

local class = {
  escape_pattern = "[%z\1-\8\11\12\14-\31\127%&%<%>%\"%']";
}

function class.escape(value, pattern)
  if pattern == nil then
    pattern = class.escape_pattern
  end
  return (tostring(value):gsub(pattern, char_refs))
end

return class
