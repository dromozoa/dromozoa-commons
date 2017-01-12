-- Copyright (C) 2015-2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local message_digest = require "dromozoa.commons.message_digest"
local uint32 = require "dromozoa.commons.uint32"

local band = uint32.band
local bxor = uint32.bxor
local bnot = uint32.bnot

local super = message_digest
local class = {
  Parity = bxor;
}

function class.Ch(x, y, z)
  return bxor(band(x, y), band(bnot(x), z))
end

function class.Maj(x, y, z)
  return bxor(band(x, y), band(x, z), band(y, z))
end

return setmetatable(class, {
  __index = super;
})
