local uint32 = require "dromozoa.commons.uint32"
assert(uint32.add(0xfeedface, 0xdeadbeef) == 0xdd9bb9bd)
assert(uint32.sub(0xfeedface, 0xdeadbeef) == 0x20403bdf)
assert(uint32.mul(0xfeedface, 0xdeadbeef) == 0xc1880a52)
assert(uint32.div(0xfeedface, 0xdeadbeef) == 0x00000001)
assert(uint32.mod(0xfeedface, 0xdeadbeef) == 0x20403bdf)
assert(uint32.band(0xfeedface, 0xdeadbeef) == 0xdeadbace)
assert(uint32.bor(0xfeedface, 0xdeadbeef) == 0xfeedfeef)
assert(uint32.bxor(0xfeedface, 0xdeadbeef) == 0x20404421)
assert(uint32.add(0xdeadbeef, 0xfeedface) == 0xdd9bb9bd)
assert(uint32.sub(0xdeadbeef, 0xfeedface) == 0xdfbfc421)
assert(uint32.mul(0xdeadbeef, 0xfeedface) == 0xc1880a52)
assert(uint32.div(0xdeadbeef, 0xfeedface) == 0x00000000)
assert(uint32.mod(0xdeadbeef, 0xfeedface) == 0xdeadbeef)
assert(uint32.band(0xdeadbeef, 0xfeedface) == 0xdeadbace)
assert(uint32.bor(0xdeadbeef, 0xfeedface) == 0xfeedfeef)
assert(uint32.bxor(0xdeadbeef, 0xfeedface) == 0x20404421)
assert(uint32.add(0xfeedface, 0x00001505) == 0xfeee0fd3)
assert(uint32.sub(0xfeedface, 0x00001505) == 0xfeede5c9)
assert(uint32.mul(0xfeedface, 0x00001505) == 0x8038cc06)
assert(uint32.div(0xfeedface, 0x00001505) == 0x000c20d3)
assert(uint32.mod(0xfeedface, 0x00001505) == 0x000007af)
assert(uint32.band(0xfeedface, 0x00001505) == 0x00001004)
assert(uint32.bor(0xfeedface, 0x00001505) == 0xfeedffcf)
assert(uint32.bxor(0xfeedface, 0x00001505) == 0xfeedefcb)
assert(uint32.shl(0xfeedface, 0) == 0xfeedface)
assert(uint32.shr(0xfeedface, 0) == 0xfeedface)
assert(uint32.rotl(0xfeedface, 0) == 0xfeedface)
assert(uint32.rotr(0xfeedface, 0) == 0xfeedface)
assert(uint32.shl(0xfeedface, 1) == 0xfddbf59c)
assert(uint32.shr(0xfeedface, 1) == 0x7f76fd67)
assert(uint32.rotl(0xfeedface, 1) == 0xfddbf59d)
assert(uint32.rotr(0xfeedface, 1) == 0x7f76fd67)
assert(uint32.shl(0xfeedface, 2) == 0xfbb7eb38)
assert(uint32.shr(0xfeedface, 2) == 0x3fbb7eb3)
assert(uint32.rotl(0xfeedface, 2) == 0xfbb7eb3b)
assert(uint32.rotr(0xfeedface, 2) == 0xbfbb7eb3)
assert(uint32.shl(0xfeedface, 3) == 0xf76fd670)
assert(uint32.shr(0xfeedface, 3) == 0x1fddbf59)
assert(uint32.rotl(0xfeedface, 3) == 0xf76fd677)
assert(uint32.rotr(0xfeedface, 3) == 0xdfddbf59)
assert(uint32.shl(0xfeedface, 4) == 0xeedface0)
assert(uint32.shr(0xfeedface, 4) == 0x0feedfac)
assert(uint32.rotl(0xfeedface, 4) == 0xeedfacef)
assert(uint32.rotr(0xfeedface, 4) == 0xefeedfac)
assert(uint32.shl(0xfeedface, 5) == 0xddbf59c0)
assert(uint32.shr(0xfeedface, 5) == 0x07f76fd6)
assert(uint32.rotl(0xfeedface, 5) == 0xddbf59df)
assert(uint32.rotr(0xfeedface, 5) == 0x77f76fd6)
assert(uint32.shl(0xfeedface, 6) == 0xbb7eb380)
assert(uint32.shr(0xfeedface, 6) == 0x03fbb7eb)
assert(uint32.rotl(0xfeedface, 6) == 0xbb7eb3bf)
assert(uint32.rotr(0xfeedface, 6) == 0x3bfbb7eb)
assert(uint32.shl(0xfeedface, 7) == 0x76fd6700)
assert(uint32.shr(0xfeedface, 7) == 0x01fddbf5)
assert(uint32.rotl(0xfeedface, 7) == 0x76fd677f)
assert(uint32.rotr(0xfeedface, 7) == 0x9dfddbf5)
assert(uint32.shl(0xfeedface, 8) == 0xedface00)
assert(uint32.shr(0xfeedface, 8) == 0x00feedfa)
assert(uint32.rotl(0xfeedface, 8) == 0xedfacefe)
assert(uint32.rotr(0xfeedface, 8) == 0xcefeedfa)
assert(uint32.shl(0xfeedface, 9) == 0xdbf59c00)
assert(uint32.shr(0xfeedface, 9) == 0x007f76fd)
assert(uint32.rotl(0xfeedface, 9) == 0xdbf59dfd)
assert(uint32.rotr(0xfeedface, 9) == 0x677f76fd)
assert(uint32.shl(0xfeedface, 10) == 0xb7eb3800)
assert(uint32.shr(0xfeedface, 10) == 0x003fbb7e)
assert(uint32.rotl(0xfeedface, 10) == 0xb7eb3bfb)
assert(uint32.rotr(0xfeedface, 10) == 0xb3bfbb7e)
assert(uint32.shl(0xfeedface, 11) == 0x6fd67000)
assert(uint32.shr(0xfeedface, 11) == 0x001fddbf)
assert(uint32.rotl(0xfeedface, 11) == 0x6fd677f7)
assert(uint32.rotr(0xfeedface, 11) == 0x59dfddbf)
assert(uint32.shl(0xfeedface, 12) == 0xdface000)
assert(uint32.shr(0xfeedface, 12) == 0x000feedf)
assert(uint32.rotl(0xfeedface, 12) == 0xdfacefee)
assert(uint32.rotr(0xfeedface, 12) == 0xacefeedf)
assert(uint32.shl(0xfeedface, 13) == 0xbf59c000)
assert(uint32.shr(0xfeedface, 13) == 0x0007f76f)
assert(uint32.rotl(0xfeedface, 13) == 0xbf59dfdd)
assert(uint32.rotr(0xfeedface, 13) == 0xd677f76f)
assert(uint32.shl(0xfeedface, 14) == 0x7eb38000)
assert(uint32.shr(0xfeedface, 14) == 0x0003fbb7)
assert(uint32.rotl(0xfeedface, 14) == 0x7eb3bfbb)
assert(uint32.rotr(0xfeedface, 14) == 0xeb3bfbb7)
assert(uint32.shl(0xfeedface, 15) == 0xfd670000)
assert(uint32.shr(0xfeedface, 15) == 0x0001fddb)
assert(uint32.rotl(0xfeedface, 15) == 0xfd677f76)
assert(uint32.rotr(0xfeedface, 15) == 0xf59dfddb)
assert(uint32.shl(0xfeedface, 16) == 0xface0000)
assert(uint32.shr(0xfeedface, 16) == 0x0000feed)
assert(uint32.rotl(0xfeedface, 16) == 0xfacefeed)
assert(uint32.rotr(0xfeedface, 16) == 0xfacefeed)
assert(uint32.shl(0xfeedface, 17) == 0xf59c0000)
assert(uint32.shr(0xfeedface, 17) == 0x00007f76)
assert(uint32.rotl(0xfeedface, 17) == 0xf59dfddb)
assert(uint32.rotr(0xfeedface, 17) == 0xfd677f76)
assert(uint32.shl(0xfeedface, 18) == 0xeb380000)
assert(uint32.shr(0xfeedface, 18) == 0x00003fbb)
assert(uint32.rotl(0xfeedface, 18) == 0xeb3bfbb7)
assert(uint32.rotr(0xfeedface, 18) == 0x7eb3bfbb)
assert(uint32.shl(0xfeedface, 19) == 0xd6700000)
assert(uint32.shr(0xfeedface, 19) == 0x00001fdd)
assert(uint32.rotl(0xfeedface, 19) == 0xd677f76f)
assert(uint32.rotr(0xfeedface, 19) == 0xbf59dfdd)
assert(uint32.shl(0xfeedface, 20) == 0xace00000)
assert(uint32.shr(0xfeedface, 20) == 0x00000fee)
assert(uint32.rotl(0xfeedface, 20) == 0xacefeedf)
assert(uint32.rotr(0xfeedface, 20) == 0xdfacefee)
assert(uint32.shl(0xfeedface, 21) == 0x59c00000)
assert(uint32.shr(0xfeedface, 21) == 0x000007f7)
assert(uint32.rotl(0xfeedface, 21) == 0x59dfddbf)
assert(uint32.rotr(0xfeedface, 21) == 0x6fd677f7)
assert(uint32.shl(0xfeedface, 22) == 0xb3800000)
assert(uint32.shr(0xfeedface, 22) == 0x000003fb)
assert(uint32.rotl(0xfeedface, 22) == 0xb3bfbb7e)
assert(uint32.rotr(0xfeedface, 22) == 0xb7eb3bfb)
assert(uint32.shl(0xfeedface, 23) == 0x67000000)
assert(uint32.shr(0xfeedface, 23) == 0x000001fd)
assert(uint32.rotl(0xfeedface, 23) == 0x677f76fd)
assert(uint32.rotr(0xfeedface, 23) == 0xdbf59dfd)
assert(uint32.shl(0xfeedface, 24) == 0xce000000)
assert(uint32.shr(0xfeedface, 24) == 0x000000fe)
assert(uint32.rotl(0xfeedface, 24) == 0xcefeedfa)
assert(uint32.rotr(0xfeedface, 24) == 0xedfacefe)
assert(uint32.shl(0xfeedface, 25) == 0x9c000000)
assert(uint32.shr(0xfeedface, 25) == 0x0000007f)
assert(uint32.rotl(0xfeedface, 25) == 0x9dfddbf5)
assert(uint32.rotr(0xfeedface, 25) == 0x76fd677f)
assert(uint32.shl(0xfeedface, 26) == 0x38000000)
assert(uint32.shr(0xfeedface, 26) == 0x0000003f)
assert(uint32.rotl(0xfeedface, 26) == 0x3bfbb7eb)
assert(uint32.rotr(0xfeedface, 26) == 0xbb7eb3bf)
assert(uint32.shl(0xfeedface, 27) == 0x70000000)
assert(uint32.shr(0xfeedface, 27) == 0x0000001f)
assert(uint32.rotl(0xfeedface, 27) == 0x77f76fd6)
assert(uint32.rotr(0xfeedface, 27) == 0xddbf59df)
assert(uint32.shl(0xfeedface, 28) == 0xe0000000)
assert(uint32.shr(0xfeedface, 28) == 0x0000000f)
assert(uint32.rotl(0xfeedface, 28) == 0xefeedfac)
assert(uint32.rotr(0xfeedface, 28) == 0xeedfacef)
assert(uint32.shl(0xfeedface, 29) == 0xc0000000)
assert(uint32.shr(0xfeedface, 29) == 0x00000007)
assert(uint32.rotl(0xfeedface, 29) == 0xdfddbf59)
assert(uint32.rotr(0xfeedface, 29) == 0xf76fd677)
assert(uint32.shl(0xfeedface, 30) == 0x80000000)
assert(uint32.shr(0xfeedface, 30) == 0x00000003)
assert(uint32.rotl(0xfeedface, 30) == 0xbfbb7eb3)
assert(uint32.rotr(0xfeedface, 30) == 0xfbb7eb3b)
assert(uint32.shl(0xfeedface, 31) == 0x00000000)
assert(uint32.shr(0xfeedface, 31) == 0x00000001)
assert(uint32.rotl(0xfeedface, 31) == 0x7f76fd67)
assert(uint32.rotr(0xfeedface, 31) == 0xfddbf59d)
assert(uint32.bnot(0xfeedface) == 0x1120531)
