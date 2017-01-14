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

local crypt_apache_md5 = require "dromozoa.commons.crypt_apache_md5"
local crypt_apache_sha1 = require "dromozoa.commons.crypt_apache_sha1"
local crypt_sha256 = require "dromozoa.commons.crypt_sha256"

return function (key, salt)
  if salt:match("^%$apr1%$") then
    return crypt_apache_md5(key, salt)
  elseif salt:match("^{SHA}") then
    return crypt_apache_sha1(key, salt)
  elseif salt:match("^%$5%$") then
    return crypt_sha256(key, salt)
  else
    return nil, "unsupported salt"
  end
end
