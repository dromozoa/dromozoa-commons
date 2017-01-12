-- Copyright (C) 2016,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
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
local sequence = require "dromozoa.commons.sequence"
local uint32 = require "dromozoa.commons.uint32"
local word_block = require "dromozoa.commons.word_block"

local add = uint32.add
local band = uint32.band
local bor = uint32.bor
local bxor = uint32.bxor
local bnot = uint32.bnot
local rotl = uint32.rotl

local S11 = 7
local S12 = 12
local S13 = 17
local S14 = 22
local S21 = 5
local S22 = 9
local S23 = 14
local S24 = 20
local S31 = 4
local S32 = 11
local S33 = 16
local S34 = 23
local S41 = 6
local S42 = 10
local S43 = 15
local S44 = 21

local function F(x, y, z)
  return bor(band(x, y), band(bnot(x), z))
end

local function G(x, y, z)
  return bor(band(x, z), band(y, bnot(z)))
end

local function H(x, y, z)
  return bxor(x, y, z)
end

local function I(x, y, z)
  return bxor(y, bor(x, bnot(z)))
end

local function FF(a, b, c, d, x, s, ac)
  local a = add(a, F(b, c, d), x, ac);
  local a = rotl(a, s)
  local a = add(a, b)
  return a
end

local function GG(a, b, c, d, x, s, ac)
  local a = add(a, G(b, c, d), x, ac);
  local a = rotl(a, s)
  local a = add(a, b)
  return a
end

local function HH(a, b, c, d, x, s, ac)
  local a = add(a, H(b, c, d), x, ac);
  local a = rotl(a, s)
  local a = add(a, b)
  return a
end

local function II(a, b, c, d, x, s, ac)
  local a = add(a, I(b, c, d), x, ac);
  local a = rotl(a, s)
  local a = add(a, b)
  return a
end

local super = message_digest
local class = {
  hex_format = ("%02x"):rep(16);
}

function class.new()
  return class.reset({
    M = word_block(16, "<");
    H = sequence();
    L = 0;
  })
end

function class:reset()
  local H = self.H
  H[1] = 0x67452301
  H[2] = 0xefcdab89
  H[3] = 0x98badcfe
  H[4] = 0x10325476
  return self
end

function class:compute()
  local M = self.M
  local H = self.H

  local a = H[1]
  local b = H[2]
  local c = H[3]
  local d = H[4]

  a = FF(a, b, c, d, M[ 1], S11, 0xd76aa478);
  d = FF(d, a, b, c, M[ 2], S12, 0xe8c7b756);
  c = FF(c, d, a, b, M[ 3], S13, 0x242070db);
  b = FF(b, c, d, a, M[ 4], S14, 0xc1bdceee);
  a = FF(a, b, c, d, M[ 5], S11, 0xf57c0faf);
  d = FF(d, a, b, c, M[ 6], S12, 0x4787c62a);
  c = FF(c, d, a, b, M[ 7], S13, 0xa8304613);
  b = FF(b, c, d, a, M[ 8], S14, 0xfd469501);
  a = FF(a, b, c, d, M[ 9], S11, 0x698098d8);
  d = FF(d, a, b, c, M[10], S12, 0x8b44f7af);
  c = FF(c, d, a, b, M[11], S13, 0xffff5bb1);
  b = FF(b, c, d, a, M[12], S14, 0x895cd7be);
  a = FF(a, b, c, d, M[13], S11, 0x6b901122);
  d = FF(d, a, b, c, M[14], S12, 0xfd987193);
  c = FF(c, d, a, b, M[15], S13, 0xa679438e);
  b = FF(b, c, d, a, M[16], S14, 0x49b40821);

  a = GG(a, b, c, d, M[ 2], S21, 0xf61e2562);
  d = GG(d, a, b, c, M[ 7], S22, 0xc040b340);
  c = GG(c, d, a, b, M[12], S23, 0x265e5a51);
  b = GG(b, c, d, a, M[ 1], S24, 0xe9b6c7aa);
  a = GG(a, b, c, d, M[ 6], S21, 0xd62f105d);
  d = GG(d, a, b, c, M[11], S22, 0x02441453);
  c = GG(c, d, a, b, M[16], S23, 0xd8a1e681);
  b = GG(b, c, d, a, M[ 5], S24, 0xe7d3fbc8);
  a = GG(a, b, c, d, M[10], S21, 0x21e1cde6);
  d = GG(d, a, b, c, M[15], S22, 0xc33707d6);
  c = GG(c, d, a, b, M[ 4], S23, 0xf4d50d87);
  b = GG(b, c, d, a, M[ 9], S24, 0x455a14ed);
  a = GG(a, b, c, d, M[14], S21, 0xa9e3e905);
  d = GG(d, a, b, c, M[ 3], S22, 0xfcefa3f8);
  c = GG(c, d, a, b, M[ 8], S23, 0x676f02d9);
  b = GG(b, c, d, a, M[13], S24, 0x8d2a4c8a);

  a = HH(a, b, c, d, M[ 6], S31, 0xfffa3942);
  d = HH(d, a, b, c, M[ 9], S32, 0x8771f681);
  c = HH(c, d, a, b, M[12], S33, 0x6d9d6122);
  b = HH(b, c, d, a, M[15], S34, 0xfde5380c);
  a = HH(a, b, c, d, M[ 2], S31, 0xa4beea44);
  d = HH(d, a, b, c, M[ 5], S32, 0x4bdecfa9);
  c = HH(c, d, a, b, M[ 8], S33, 0xf6bb4b60);
  b = HH(b, c, d, a, M[11], S34, 0xbebfbc70);
  a = HH(a, b, c, d, M[14], S31, 0x289b7ec6);
  d = HH(d, a, b, c, M[ 1], S32, 0xeaa127fa);
  c = HH(c, d, a, b, M[ 4], S33, 0xd4ef3085);
  b = HH(b, c, d, a, M[ 7], S34, 0x04881d05);
  a = HH(a, b, c, d, M[10], S31, 0xd9d4d039);
  d = HH(d, a, b, c, M[13], S32, 0xe6db99e5);
  c = HH(c, d, a, b, M[16], S33, 0x1fa27cf8);
  b = HH(b, c, d, a, M[ 3], S34, 0xc4ac5665);

  a = II(a, b, c, d, M[ 1], S41, 0xf4292244);
  d = II(d, a, b, c, M[ 8], S42, 0x432aff97);
  c = II(c, d, a, b, M[15], S43, 0xab9423a7);
  b = II(b, c, d, a, M[ 6], S44, 0xfc93a039);
  a = II(a, b, c, d, M[13], S41, 0x655b59c3);
  d = II(d, a, b, c, M[ 4], S42, 0x8f0ccc92);
  c = II(c, d, a, b, M[11], S43, 0xffeff47d);
  b = II(b, c, d, a, M[ 2], S44, 0x85845dd1);
  a = II(a, b, c, d, M[ 9], S41, 0x6fa87e4f);
  d = II(d, a, b, c, M[16], S42, 0xfe2ce6e0);
  c = II(c, d, a, b, M[ 7], S43, 0xa3014314);
  b = II(b, c, d, a, M[14], S44, 0x4e0811a1);
  a = II(a, b, c, d, M[ 5], S41, 0xf7537e82);
  d = II(d, a, b, c, M[12], S42, 0xbd3af235);
  c = II(c, d, a, b, M[ 3], S43, 0x2ad7d2bb);
  b = II(b, c, d, a, M[10], S44, 0xeb86d391);

  H[1] = add(H[1], a)
  H[2] = add(H[2], b)
  H[3] = add(H[3], c)
  H[4] = add(H[4], d)
end

function class.bin(message)
  return class():update(message):finalize("bin")
end

function class.hex(message)
  return class():update(message):finalize("hex")
end

function class.hmac(K, text, encode)
  return super.hmac(class, K, text, encode)
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __index = super;
  __call = function ()
    return setmetatable(class.new(), class.metatable)
  end;
})
