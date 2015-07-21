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

local murmur3 = require "dromozoa.commons.hash.murmur3"

assert(murmur3.string("") == 0)
assert(murmur3.string("a") == 1009084850)
assert(murmur3.string("ab") == 2613040991)
assert(murmur3.string("abc") == 3017643002)
assert(murmur3.string("abcd") == 1139631978)
assert(murmur3.string("abcde") == 3902511862)
assert(murmur3.string("abcdef") == 1635893381)
assert(murmur3.string("abcdefg") == 2285673222)
assert(murmur3.string("abcdefgh") == 1239272644)
assert(murmur3.string("abcdefghi") == 1108608752)
assert(murmur3.uint32(0xFEEDFACE) == 298348117)
assert(murmur3.uint64(0xFEEDFACE0000) == 860420484)
assert(murmur3.double(math.pi) == 2303256014)
