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

local md5 = require "dromozoa.commons.md5"
local sequence_writer = require "dromozoa.commons.sequence_writer"
local uint32 = require "dromozoa.commons.uint32"
local crypt_base64 = require "dromozoa.commons.crypt_base64"

local function loop(rounds, A_C, P, S)
  for i = 1, rounds do
    local C = md5()
    if i % 2 == 0 then
      C:update(P)
    else
      C:update(A_C)
    end
    if i % 3 ~= 1 then
      C:update(S)
    end
    if i % 7 ~= 1 then
      C:update(P)
    end
    if i % 2 == 0 then
      C:update(A_C)
    else
      C:update(P)
    end
    A_C = C:finalize("bin")
  end
  return A_C
end

return function (key, salt)
  local salt_string = salt:match("^%$apr1%$([^%$]+)")
  if salt_string then
    salt_string = salt_string:sub(1, 8)
  else
    return nil, "unsupported salt"
  end

  local B = md5()
  B:update(key)
  B:update(salt_string)
  B:update(key)
  local B = B:finalize("bin")

  local A = md5()
  A:update(key)
  A:update("$apr1$")
  A:update(salt_string)
  local n = #key
  while n > 16 do
    n = n - 16
    A:update(B)
  end
  A:update(B:sub(1, n))
  local n = #key
  while n > 0 do
    if uint32.band(n, 1) == 1 then
      A:update("\0")
    else
      A:update(key:sub(1, 1))
    end
    n = uint32.shr(n, 1)
  end
  local A = A:finalize("bin")

  local C = loop(1000, A, key, salt_string)

  local out = sequence_writer()
  out:write("$apr1$", salt_string, "$")
  crypt_base64.encode(out, C, 1, 7, 13)
  crypt_base64.encode(out, C, 2, 8, 14)
  crypt_base64.encode(out, C, 3, 9, 15)
  crypt_base64.encode(out, C, 4, 10, 16)
  crypt_base64.encode(out, C, 5, 11, 6)
  crypt_base64.encode(out, C, 12)
  return out:concat()
end
