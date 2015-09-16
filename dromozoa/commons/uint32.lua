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

local function add(a, b)
  return (a + b) % 0x100000000
end

local function sub(a, b)
  return (a - b) % 0x100000000
end

local function mul(a, b)
  local a1 = a % 0x10000
  local a2 = (a - a1) / 0x10000
  local c1 = a1 * b
  local c2 = a2 * b % 0x10000
  return (c1 + c2 * 0x10000) % 0x100000000
end

local function div(a, b)
  local c = a / b
  return c - c % 1
end

local function mod(a, b)
  return a % b
end

local function band(a, b)
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
  return c
end

local function bor(a, b)
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
  return c
end

local function bxor(a, b)
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
  return c
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

if _VERSION >= "Lua 5.3" then
  return assert(load([[
    return {
      add = function (a, b)
        return a + b & 0xFFFFFFFF
      end;
      sub = function (a, b)
        return a - b & 0xFFFFFFFF
      end;
      mul = function (a, b)
        return a * b & 0xFFFFFFFF
      end;
      div = function (a, b)
        return a // b
      end;
      mod = function (a, b)
        return a % b
      end;
      band = function (a, b)
        return a & b
      end;
      bor = function (a, b)
        return a | b
      end;
      bxor = function (a, b)
        return a ~ b
      end;
      shl = function (a, b)
        return a << b & 0xFFFFFFFF
      end;
      shr = function (a, b)
        return a >> b
      end;
      bnot = function (v)
        return ~v & 0xFFFFFFFF
      end;
      rotl = function (a, b)
        return (a << b | a >> 32 - b) & 0xFFFFFFFF
      end;
      rotr = function (a, b)
        return (a >> b | a << 32 - b) & 0xFFFFFFFF
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
  }
elseif bit then
  return {
    add = add;
    sub = sub;
    mul = mul;
    div = div;
    mod = mod;
    band = function (a, b)
      return bit.band(a, b) % 0x100000000
    end;
    bor = function (a, b)
      return bit.bor(a, b) % 0x100000000
    end;
    bxor = function (a, b)
      return bit.bxor(a, b) % 0x100000000
    end;
    shl = function (a, b)
      return bit.lshift(a, b) % 0x100000000
    end;
    shr = function (a, b)
      return bit.rshift(a, b) % 0x100000000
    end;
    bnot = function (v)
      return bit.bnot(v) % 0x100000000
    end;
    rotl = function (a, b)
      return bit.rol(a, b) % 0x100000000
    end;
    rotr = function (a, b)
      return bit.ror(a, b) % 0x100000000
    end;
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
  }
end
