#!/usr/bin/env perl

use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN {
    if (-d 't') {
        # running from the base directory
        unshift @INC, 'lib';
    }   
    else {
        unshift @INC, '../lib';
    }   
}

use CodeGen::Constants qw(:mybatis);
use CodeGen::Util qw(
    to_snake_case
    get_template_prefix_dir
);

my $exp;
my $act;
# test camel case to snake case
$exp = "db_config_properties";
$act = to_snake_case("DBConfigProperties");
is($act, $exp, "camel case to snake case test 1");

# test camel case to snake case
$exp = "db_config_properties";
$act = to_snake_case("DbConfigProperties");
is($act, $exp, "camel case to snake case test 2");

# test camel case to snake case
$exp = "db_config_properties";
$act = to_snake_case("dbConfigProperties");
is($act, $exp, "camel case to snake case test 3");

# test get template prefix dir
$exp = "GWT/UiBinder";
$act = get_template_prefix_dir("CodeGen::GWT::UiBinder::Part::Gradle");
is($act, $exp, "get_template_prefix_dir test 1");

# test get template prefix dir
$exp = "MyBatis";
$act = get_template_prefix_dir("CodeGen::MyBatis::Part::Gradle");
is($act, $exp, "get_template_prefix_dir test 1");

# test get template prefix dir
$exp = "";
$act = get_template_prefix_dir("CodeGen::MyBatis::Part");
is($act, $exp, "get_template_prefix_dir test 2");

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
