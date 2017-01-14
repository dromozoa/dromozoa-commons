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

local crypt_sha256 = require "dromozoa.commons.crypt_sha256"

local mode = ...

local function test(key, salt_string, expected)
  local result = crypt_sha256(key, salt_string)
  if mode == "all" then
    print(result)
  end
  assert(result == expected)
end

test(
    "Hello world!",
    "$5$saltstring",
    "$5$saltstring$5B8vYYiY.CVt1RlTTf8KbXBH3hsxY/GNooZaBBGWEc5")

if mode == "all" then
  test(
      "Hello world!",
      "$5$rounds=10000$saltstringsaltstring",
      "$5$rounds=10000$saltstringsaltst$3xv.VbSHBb41AL9AvLeujZkZRBAwqFMz2.opqey6IcA")
  test(
      "This is just a test",
      "$5$rounds=5000$toolongsaltstring",
      "$5$rounds=5000$toolongsaltstrin$Un/5jzAHMgOGZ5.mWJpuVolil07guHPvOW8mGRcvxa5")
  test(
      "a very much longer text to encrypt.  This one even stretches over morethan one line.",
      "$5$rounds=1400$anotherlongsaltstring",
      "$5$rounds=1400$anotherlongsalts$Rx.j8H.h8HjEDGomFU8bDkXm3XIUnzyxf12oP84Bnq1")
  test(
      "we have a short salt string but not a short password",
      "$5$rounds=77777$short",
      "$5$rounds=77777$short$JiO1O3ZpDAxGJeaDIuqCoEFysAe1mZNJRs3pw0KQRd/")
  test(
      "a short string",
      "$5$rounds=123456$asaltof16chars..",
      "$5$rounds=123456$asaltof16chars..$gP3VQ/6X7UUEW3HkBn2w1/Ptq2jxPyzV/cZKmF/wJvD")
  test(
      "the minimum number is still observed",
      "$5$rounds=10$roundstoolow",
      "$5$rounds=1000$roundstoolow$yfvwcWrQ8l/K0DAWyuPMDNHpIVlTQebY9l/gL972bIC")
end
