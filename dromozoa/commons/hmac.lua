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
  local H = h:finalize()
  local bin = sequence()
  for i = 1, 8 do
    local a = H[i]
    local d = a % 256
    local a = (a - d) / 256
    local c = a % 256
    local a = (a - c) / 256
    local b = a % 256
    local a = (a - b) / 256
    bin:push(string.char(a, b, c, d))
  end
  local h = hash()
  h:update_hmac(K, 0x5c5c5c5c)
  h:update(bin:concat())
  local H = h:finalize()
  return ("%08x%08x%08x%08x%08x%08x%08x%08x"):format(H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8])
end

local class = {}

function class.sha256(K, text)
  return hmac(sha256, K, text)
end

return class
