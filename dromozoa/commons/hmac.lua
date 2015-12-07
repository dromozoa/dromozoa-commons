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
local sha256 = require "dromozoa.commons.sha256"

local function hmac(hash, K, text)
  local h = hash()
  h:update_hmac(K, 0x36363636)
  h:update(text)
  local H = h:finalize("bin")
  local h = hash()
  h:update_hmac(K, 0x5c5c5c5c)
  h:update(H)
  return h:finalize("hex")
end

local class = {}

function class.sha256(K, text)
  return hmac(sha256, K, text)
end

return class
