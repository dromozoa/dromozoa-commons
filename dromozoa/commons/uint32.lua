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

local function add(a, b, x, ...)
  local c = (a + b) % 0x100000000
  if x == nil then
    return c
  else
    return add(c, x, ...)
  end
end

local function sub(a, b)
  return (a - b) % 0x100000000
end

local function mul(a, b, x, ...)
  local a1 = a % 0x10000
  local a2 = (a - a1) / 0x10000
  local c1 = a1 * b
  local c2 = a2 * b % 0x10000
  local c = (c1 + c2 * 0x10000) % 0x100000000
  if x == nil then
    return c
  else
    return mul(c, x, ...)
  end
end

local function div(a, b)
  local c = a / b
  return c - c % 1
end

local function mod(a, b)
  return a % b
end

local function band(a, b, x, ...)
  local c = 0
  local d = 1
  for i = 1, 31 do
    local a1 = a % 2
    local b1 = b % 2
    if a1 + b1 == 2 then
      c = c + d
    end
    a = (a - a1) / 2
    b = (b - b1) / 2
    d = d * 2
  end
  if a + b == 2 then
    c = c + d
  end
  if x == nil then
    return c
  else
    return band(c, x, ...)
  end
end

local function bor(a, b, x, ...)
  local c = 0
  local d = 1
  for i = 1, 31 do
    local a1 = a % 2
    local b1 = b % 2
    if a1 + b1 ~= 0 then
      c = c + d
    end
    a = (a - a1) / 2
    b = (b - b1) / 2
    d = d * 2
  end
  if a + b ~= 0 then
    c = c + d
  end
  if x == nil then
    return c
  else
    return bor(c, x, ...)
  end
end

local function bxor(a, b, x, ...)
  local c = 0
  local d = 1
  for i = 1, 31 do
    local a1 = a % 2
    local b1 = b % 2
    if a1 ~= b1 then
      c = c + d
    end
    a = (a - a1) / 2
    b = (b - b1) / 2
    d = d * 2
  end
  if a ~= b then
    c = c + d
  end
  if x == nil then
    return c
  else
    return bxor(c, x, ...)
  end
end

local function bnot(v)
  local c = 0
  local d = 1
  for i = 1, 31 do
    local v1 = v % 2
    if v1 == 0 then
      c = c + d
    end
    v = (v - v1) / 2
    d = d * 2
  end
  if v == 0 then
    c = c + d
  end
  return c
end

local function shl(a, b)
  local b1 = 2 ^ b
  local b2 = 0x100000000 / b1
  return a % b2 * b1
end

local function shr(a, b)
  local b1 = 2 ^ b
  local c = a / b1
  return c - c % 1
end

local function rotl(a, b)
  local b1 = 2 ^ b
  local b2 = 0x100000000 / b1
  local c1 = a % b2
  local c2 = (a - c1) / b2
  return c1 * b1 + c2
end

local function rotr(a, b)
  local b1 = 2 ^ b
  local b2 = 0x100000000 / b1
  local c1 = a % b1
  local c2 = (a - c1) / b1
  return c1 * b2 + c2
end

local function byte(v, endian)
  local d = v % 0x100
  local v = (v - d) / 0x100
  local c = v % 0x100
  local v = (v - c) / 0x100
  local b = v % 0x100
  local a = (v - b) / 0x100
  if endian == ">" then
    return a, b, c, d
  else
    return d, c, b, a
  end
end

local function char(v, endian)
  return string.char(byte(v, endian))
end

if _VERSION >= "Lua 5.3" then
  return assert(load([[
    local function add(a, b, x, ...)
      local c = a + b & 0xffffffff
      if x == nil then
        return c
      else
        return add(c, x, ...)
      end
    end

    local function mul(a, b, x, ...)
      local c = a * b & 0xffffffff
      if x == nil then
        return c
      else
        return mul(c, x, ...)
      end
    end

    local function band(a, b, x, ...)
      local c = a & b
      if x == nil then
        return c
      else
        return band(c, x, ...)
      end
    end

    local function bor(a, b, x, ...)
      local c = a | b
      if x == nil then
        return c
      else
        return bor(c, x, ...)
      end
    end

    local function bxor(a, b, x, ...)
      local c = a ~ b
      if x == nil then
        return c
      else
        return bxor(c, x, ...)
      end
    end

    return {
      add = add;
      sub = function (a, b)
        return a - b & 0xffffffff
      end;
      mul = mul;
      div = function (a, b)
        return a // b
      end;
      mod = function (a, b)
        return a % b
      end;
      band = band;
      bor = bor;
      bxor = bxor;
      shl = function (a, b)
        return a << b & 0xffffffff
      end;
      shr = function (a, b)
        return a >> b
      end;
      bnot = function (v)
        return ~v & 0xffffffff
      end;
      rotl = function (a, b)
        return (a << b | a >> 32 - b) & 0xffffffff
      end;
      rotr = function (a, b)
        return (a >> b | a << 32 - b) & 0xffffffff
      end;
      byte = function (v, endian)
        local a, b, c, d = ("BBBB"):unpack((">I4"):pack(v))
        if endian == ">" then
          return a, b, c, d
        else
          return d, c, b, a
        end
      end;
      char = function (v, endian)
        if endian == ">" then
          return (">I4"):pack(v)
        else
          return ("<I4"):pack(v)
        end
      end;
    }
  ]]))()
elseif bit32 then
  return {
    add = add;
    sub = sub;
    mul = mul;
    div = div;
    mod = mod;
    band = bit32.band;
    bor = bit32.bor;
    bxor = bit32.bxor;
    shl = bit32.lshift;
    shr = bit32.rshift;
    bnot = bit32.bnot;
    rotl = bit32.lrotate;
    rotr = bit32.rrotate;
    byte = byte;
    char = char;
  }
elseif bit then
  local bit_band = bit.band
  local bit_bor = bit.bor
  local bit_bxor = bit.bxor
  local bit_lshift = bit.lshift
  local bit_rshift = bit.rshift
  local bit_bnot = bit.bnot
  local bit_rol = bit.rol
  local bit_ror = bit.ror
  return {
    add = add;
    sub = sub;
    mul = mul;
    div = div;
    mod = mod;
    band = function (...)
      return bit_band(...) % 0x100000000
    end;
    bor = function (...)
      return bit_bor(...) % 0x100000000
    end;
    bxor = function (...)
      return bit_bxor(...) % 0x100000000
    end;
    shl = function (a, b)
      return bit_lshift(a, b) % 0x100000000
    end;
    shr = function (a, b)
      return bit_rshift(a, b) % 0x100000000
    end;
    bnot = function (v)
      return bit_bnot(v) % 0x100000000
    end;
    rotl = function (a, b)
      return bit_rol(a, b) % 0x100000000
    end;
    rotr = function (a, b)
      return bit_ror(a, b) % 0x100000000
    end;
    byte = byte;
    char = char;
  }
else
  return {
    add = add;
    sub = sub;
    mul = mul;
    div = div;
    mod = mod;
    band = band;
    bor = bor;
    bxor = bxor;
    shl = shl;
    shr = shr;
    bnot = bnot;
    rotl = rotl;
    rotr = rotr;
    byte = byte;
    char = char;
  }
end
