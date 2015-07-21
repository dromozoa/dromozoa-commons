local djb2 = require "dromozoa.commons.hash.djb2"
assert(djb2.string("") == 5381)
assert(djb2.string("a") == 177670)
assert(djb2.string("ab") == 5863208)
assert(djb2.string("abc") == 193485963)
assert(djb2.string("abcd") == 2090069583)
assert(djb2.string("abcde") == 252819604)
assert(djb2.string("abcdef") == 4048079738)
assert(djb2.string("abcdefg") == 442645281)
assert(djb2.string("abcdefgh") == 1722392489)
assert(djb2.string("abcdefghi") == 1004377394)
assert(djb2.uint32(0) == 2086473605)
assert(djb2.uint32(1) == 2086509542)
assert(djb2.uint64(0) == 2075347461)
assert(djb2.uint64(1) == 1744117478)
assert(djb2.double(0) == 2075347461)
assert(djb2.double(1) == 2075355444)
