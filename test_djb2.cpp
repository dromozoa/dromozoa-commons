// Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
//
// This file is part of dromozoa-commons.
//
// dromozoa-commons is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// dromozoa-commons is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with dromozoa-commons.  If not, see <http://www.gnu.org/licenses/>.

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iostream>

std::uint32_t djb2(const std::uint8_t* ptr, std::size_t size) {
  std::uint32_t hash = 5381;
  const std::uint8_t* end = ptr + size;
  for (; ptr != end; ++ptr) {
    hash = (hash << 5) + hash + *ptr;
  }
  return hash;
}

void make_test(const char* s) {
  std::cout
      << "assert(djb2.string(\"" << s << "\", 5381) == "
      << djb2(reinterpret_cast<const std::uint8_t*>(s), std::strlen(s))
      << ")\n";
}

template <class T>
void make_test2(T v, const char* type) {
  union {
    T v;
    uint8_t p[1];
  } u;
  u.v = v;
  std::cout
      << "assert(djb2." << type << "(" << v << ", 5381) == "
      << djb2(u.p, sizeof(T))
      << ")\n";
}

int main(int, char*[]) {
  std::cout << "local djb2 = require \"dromozoa.commons.hash.djb2\"\n";
  make_test("");
  make_test("a");
  make_test("ab");
  make_test("abc");
  make_test("abcd");
  make_test("abcde");
  make_test("abcdef");
  make_test("abcdefg");
  make_test("abcdefgh");
  make_test("abcdefghi");
  make_test2<std::uint32_t>(0, "uint32");
  make_test2<std::uint32_t>(1, "uint32");
  make_test2<std::uint64_t>(0, "uint64");
  make_test2<std::uint64_t>(1, "uint64");
  make_test2<double>(0, "double");
  make_test2<double>(1, "double");
  return 0;
}
