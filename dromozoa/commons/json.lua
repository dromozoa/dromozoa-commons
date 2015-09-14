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

local quote_char = {
  [string.char(0x22)] = [[\"]];
  [string.char(0x5C)] = [[\\]];
  [string.char(0x2F)] = [[\/]];
  [string.char(0x08)] = [[\b]];
  [string.char(0x0C)] = [[\f]];
  [string.char(0x0A)] = [[\n]];
  [string.char(0x0D)] = [[\r]];
  [string.char(0x09)] = [[\t]];
}

for i = 0x00, 0x19 do
  local char = string.char(i)
  if quote_char[char] == nil then
    quote_char[char] = string.format([[\u%04X]], i)
  end
end

return {
  quote = function (value)
    return [["]] .. value:gsub("[\"\\/\0-\31]", quote_char) .. [["]]
  end;
}
