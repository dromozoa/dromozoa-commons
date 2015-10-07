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

local bitset = require "dromozoa.commons.bitset"

local function byte(s)
  local n = #s
  assert(n == 1 or n == 2)
  return string.byte(s, 1, n)
end

local class = {}

function class.get_posix_character_classes()
  local character_classes = {}

  character_classes.upper = bitset()
    :set(byte("AZ"))

  character_classes.lower = bitset()
    :set(byte("az"))

  character_classes.alpha = bitset()
    :set_union(character_classes.upper)
    :set_union(character_classes.lower)

  character_classes.digit = bitset()
    :set(byte("09"))

  character_classes.alnum = bitset()
    :set_union(character_classes.alpha)
    :set_union(character_classes.digit)

  character_classes.space = bitset()
    :set(byte(" "))
    :set(byte("\f"))
    :set(byte("\n"))
    :set(byte("\r"))
    :set(byte("\t"))
    :set(byte("\v"))

  character_classes.cntrl = bitset()
    :set(0, 31)
    :set(127)

  character_classes.punct = bitset()
    :set(byte("!/"))
    :set(byte(":@"))
    :set(byte("[`"))
    :set(byte("{~"))

  character_classes.graph = bitset()
    :set_union(character_classes.alnum)
    :set_union(character_classes.punct)

  character_classes.print = bitset()
    :set_union(character_classes.graph)
    :set(byte(" "))

  character_classes.xdigit = bitset()
    :set(byte("09"))
    :set(byte("AF"))
    :set(byte("af"))

  character_classes.blank = bitset()
    :set(byte(" "))
    :set(byte("\t"))

  return character_classes
end

function class.get_posix_collating_elements()
  local collating_elements = {}
  for i = 0, 127 do
    collating_elements[string.char(i)] = i
  end
  return collating_elements
end

function class.get_extended_collating_elements()
  local collating_elements = {}
  for i = 0, 255 do
    collating_elements[string.char(i)] = i
    collating_elements[string.format("x%02X", i)] = i
  end
  return collating_elements
end

class.character_classes = class.get_posix_character_classes()
class.collating_elements = class.get_extended_collating_elements()

return class
