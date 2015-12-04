# Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
#
# This file is part of dromozoa-prl.
#
# dromozoa-prl is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# dromozoa-prl is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with dromozoa-prl.  If not, see <http://www.gnu.org/licenses/>.

TARGET = test_uint32

CFLAGS = -g -O2
CPPFLAGS =
CXXFLAGS = -Wall -W -std=c++11 $(CFLAGS)
LDFLAGS =
LDLIBS =

TARGET = test_sha256.lua test_uint32.lua

all: $(TARGET)

clean:
	rm -f *.o test_uint32

test_sha256.lua: test_sha256.pl
	./test_sha256.pl >$@

test_uint32: test_uint32.o
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

test_uint32.o: test_uint32.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<

test_uint32.lua: test_uint32
	./test_uint32 >$@
