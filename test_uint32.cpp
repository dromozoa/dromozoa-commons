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

#include <cstdint>
#include <iomanip>
#include <iostream>

uint32_t rotl(std::uint32_t a, std::uint32_t b) {
  return (a << b) | (a >> (32 - b));
}

uint32_t rotr(std::uint32_t a, std::uint32_t b) {
  return (a >> b) | (a << (32 - b));
}

void make_test1(std::uint32_t a, std::uint32_t b) {
  std::cout
      << std::hex
      << "assert(uint32.add("
      << "0x" << std::setw(8) << a << ", "
      << "0x" << std::setw(8) << b << ") == "
      << "0x" << std::setw(8) << (a + b) << ")"
      << "\n"
      << "assert(uint32.sub("
      << "0x" << std::setw(8) << a << ", "
      << "0x" << std::setw(8) << b << ") == "
      << "0x" << std::setw(8) << (a - b) << ")"
      << "\n"
      << "assert(uint32.mul("
      << "0x" << std::setw(8) << a << ", "
      << "0x" << std::setw(8) << b << ") == "
      << "0x" << std::setw(8) << (a * b) << ")"
      << "\n"
      << "assert(uint32.div("
      << "0x" << std::setw(8) << a << ", "
      << "0x" << std::setw(8) << b << ") == "
      << "0x" << std::setw(8) << (a / b) << ")"
      << "\n"
      << "assert(uint32.mod("
      << "0x" << std::setw(8) << a << ", "
      << "0x" << std::setw(8) << b << ") == "
      << "0x" << std::setw(8) << (a % b) << ")"
      << "\n"
      << "assert(uint32.band("
      << "0x" << std::setw(8) << a << ", "
      << "0x" << std::setw(8) << b << ") == "
      << "0x" << std::setw(8) << (a & b) << ")"
      << "\n"
      << "assert(uint32.bor("
      << "0x" << std::setw(8) << a << ", "
      << "0x" << std::setw(8) << b << ") == "
      << "0x" << std::setw(8) << (a | b) << ")"
      << "\n"
      << "assert(uint32.bxor("
      << "0x" << std::setw(8) << a << ", "
      << "0x" << std::setw(8) << b << ") == "
      << "0x" << std::setw(8) << (a ^ b) << ")"
      << "\n"
      ;
}

void make_test2(std::uint32_t v) {
  for (std::uint32_t i = 0; i < 32; ++i) {
    std::cout
        << "assert(uint32.shl("
        << "0x" << std::hex << std::setw(8) << v << ", "
        << std::dec << i << ") == "
        << "0x" << std::hex << std::setw(8) << (v << i) << ")"
        << "\n"
        << "assert(uint32.shr("
        << "0x" << std::hex << std::setw(8) << v << ", "
        << std::dec << i << ") == "
        << "0x" << std::hex << std::setw(8) << (v >> i) << ")"
        << "\n"
        << "assert(uint32.rotl("
        << "0x" << std::hex << std::setw(8) << v << ", "
        << std::dec << i << ") == "
        << "0x" << std::hex << std::setw(8) << rotl(v, i) << ")"
        << "\n"
        << "assert(uint32.rotr("
        << "0x" << std::hex << std::setw(8) << v << ", "
        << std::dec << i << ") == "
        << "0x" << std::hex << std::setw(8) << rotr(v, i) << ")"
        << "\n"
        ;
  }
  std::cout
      << std::hex
      << "assert(uint32.bnot("
      << "0x" << std::setw(8) << v << ") == "
      << "0x" << std::setw(8) << (~v) << ")"
      << "\n"
      ;
}

int main(int, char*[]) {
  std::cout
      << std::setfill('0')
      << "local uint32 = require \"dromozoa.commons.uint32\""
      << "\n"
      ;
  make_test1(0xFEEDFACE, 0xDEADBEEF);
  make_test1(0xDEADBEEF, 0xFEEDFACE);
  make_test1(0xFEEDFACE, 5381);
  make_test2(0xFEEDFACE);
  return 0;
}
