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
  local c = a + b
  return c % 0x100000000
end

local function sub(a, b)
  local c = a - b
  return c % 0x100000000
end

local function mul(a, b)
  local a1 = a % 0x10000
  local a2 = (a - a1) / 0x10000
  local c1 = a1 * b
  local c2 = a2 * b % 0x10000
  local c = c1 + c2 * 0x10000
  return c % 0x100000000
end

local function div(a, b)
  local c = a / b
  return c - c % 1
end

local function mod(a, b)
  local c = a % b
  return c
end

local function band(a, b)
  local c = 1
  local d = 0
  for i = 1, 31 do
    local a1 = a % 2
    local b1 = b % 2
    if a1 + b1 == 2 then
      d = c + d
    end
    a = (a - a1) / 2
    b = (b - b1) / 2
    c = c * 2
  end
  if a + b == 2 then
    d = c + d
  end
  return d
end

local function bor(a, b)
  local c = 1
  local d = 0
  for i = 1, 31 do
    local a1 = a % 2
    local b1 = b % 2
    if a1 + b1 ~= 0 then
      d = c + d
    end
    a = (a - a1) / 2
    b = (b - b1) / 2
    c = c * 2
  end
  if a + b ~= 0 then
    d = c + d
  end
  return d
end

local function bxor(a, b)
  local c = 1
  local d = 0
  for i = 1, 31 do
    local a1 = a % 2
    local b1 = b % 2
    if a1 ~= b1 then
      d = c + d
    end
    a = (a - a1) / 2
    b = (b - b1) / 2
    c = c * 2
  end
  if a ~= b then
    d = c + d
  end
  return d
end

local function shl(a, b)
  local b1 = 2 ^ b
  local b2 = 0x100000000 / b1
  local c = a % b2 * b1
  return c
end

local function shr(a, b)
  local b1 = 2 ^ b
  local c = a / b1
  return c - c % 1
end

local function bnot(a)
  local b = 1
  local c = 0
  for i = 1, 31 do
    local a1 = a % 2
    if a1 == 0 then
      c = b + c
    end
    a = (a - a1) / 2
    b = b * 2
  end
  if a == 0 then
    c = b + c
  end
  return c
end

local function rotl(a, b)
  local b1 = 2 ^ b
  local b2 = 0x100000000 / b1
  local a1 = a % b2
  local a2 = (a - a1) / b2
  local c = a1 * b1 + a2
  return c
end

local function rotr(a, b)
  local b1 = 2 ^ b
  local b2 = 0x100000000 / b1
  local a1 = a % b1
  local a2 = (a - a1) / b1
  local c = a1 * b2 + a2
  return c
end

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
