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

local encoder = {}

for i = 0, 255 do
  encoder[string.char(i)] = ("%%%02X"):format(i)
end

local encoder_html5 = setmetatable({
  [" "] = "+";
}, { __index = encoder })

local function decode(s)
  return string.char(tonumber(s, 16))
end

local class = {}

-- https://tools.ietf.org/html/rfc3986#section-2.3
function class.encode_rfc3986(s)
  return (tostring(s):gsub("[^A-Za-z0-9%-%.%_%~]", encoder))
end

-- http://www.w3.org/TR/html5/forms.html#url-encoded-form-data
function class.encode_html5(s)
  return (tostring(s):gsub("[^%*%-%.0-9A-Z_a-z]", encoder_html5))
end

function class.decode(s)
  return (tostring(s):gsub("%+", " "):gsub("%%(%x%x)", decode))
end

class.encode = class.encode_rfc3986

return class
