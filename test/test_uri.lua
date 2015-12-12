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

local uri = require "dromozoa.commons.uri"

assert(uri.encode(" ") == "%20")
assert(uri.encode("'()") == "%27%28%29")
assert(uri.encode("*") == "%2A")
assert(uri.encode("+") == "%2B")
assert(uri.encode("日本語") == "%E6%97%A5%E6%9C%AC%E8%AA%9E")
assert(uri.encode_rfc3986(" ") == "%20")
assert(uri.encode_rfc3986("'()") == "%27%28%29")
assert(uri.encode_rfc3986("*") == "%2A")
assert(uri.encode_rfc3986("+") == "%2B")
assert(uri.encode_rfc3986("日本語") == "%E6%97%A5%E6%9C%AC%E8%AA%9E")
assert(uri.encode_html5(" ") == "+")
assert(uri.encode_html5("'()") == "%27%28%29")
assert(uri.encode_html5("*") == "*")
assert(uri.encode_html5("+") == "%2B")
assert(uri.encode_html5("日本語") == "%E6%97%A5%E6%9C%AC%E8%AA%9E")

assert(uri.decode("%20+") == "  ")
assert(uri.decode("%27%28%29") == "'()")
assert(uri.decode("%2A*") == "**")
assert(uri.decode("%2B") == "+")
assert(uri.decode("%E6%97%A5%E6%9C%AC%E8%AA%9E") == "日本語")
