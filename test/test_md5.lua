-- Copyright (C) 2016 Tomoyuki Fujimori <moyu@dromozoa.com>
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

local base16 = require "dromozoa.commons.base16"
local md5 = require "dromozoa.commons.md5"

data = {
  { "",
    "d41d8cd98f00b204e9800998ecf8427e" },
  { "a",
    "0cc175b9c0f1b6a831c399e269772661" },
  { "abc",
    "900150983cd24fb0d6963f7d28e17f72" },
  { "message digest",
    "f96b697d7cb7938d525a2f31aaf161d0" },
  { "abcdefghijklmnopqrstuvwxyz",
    "c3fcd3d76192e4007dfb496cca67e13b" },
  { "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
    "d174ab98d277d9f5a5611c2c9f419d9f" },
  { "12345678901234567890123456789012345678901234567890123456789012345678901234567890",
    "57edf4a22be3c955ac49da2e2107b67a" },
}

for i, v in ipairs(data) do
  assert(md5.hex(v[1]) == v[2])
  assert(base16.encode_lower(md5.bin(v[1])) == v[2])
end
