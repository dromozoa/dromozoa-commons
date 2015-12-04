#! /usr/bin/env perl

# Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
#
# This file is part of dromozoa-commons.
#
# dromozoa-commons is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# dromozoa-commons is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with dromozoa-commons.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use Digest::SHA qw{sha256_hex};

print "{\n";
my $message = "";
printf qq|  { "%s",\n    "%s" },\n|, $message, sha256_hex $message;
for (my $i = 0; $i < 128; ++$i) {
  $message .= chr($i % 26 + 97);
  printf qq|  { "%s",\n    "%s" },\n|, $message, sha256_hex $message;
}
print "}\n";
