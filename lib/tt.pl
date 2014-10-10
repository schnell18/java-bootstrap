#!/usr/bin/env perl

use strict;
use warnings;
use CodeGen::Constants qw();
# use CodeGen::Base::Generator;

while(my($key, $val) = each(%INC)) {
    printf "%s => %s\n", $key, $val;
}
