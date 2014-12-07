#!/usr/bin/env perl

use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Spec::Functions qw(rel2abs updir catdir catfile);
use Test::More qw(no_plan);
use Test::Deep;

BEGIN {
    if (-d 't') {
        # running from the base directory
        unshift @INC, 'lib'
    }
    else {
        unshift @INC, '../lib';
    }
}

use CodeGen::Constants qw(:all);
use CodeGen::GWT::Generator::GwtBoot;

# setup test directory
my $meta_dir = ".meta";
$meta_dir = -d $meta_dir ? rel2abs(".meta")
                         : rel2abs(catdir("t", ".meta"));
my $test_case = "tc2";
my $base_dir = tempdir('__CGXXXXXX', DIR => File::Spec->tmpdir());
my $project_dir = "abc";
# call setup script to initialize test repository and make commits
printf "Setting up test directory at %s\n", $base_dir;

my $root_pkg    = "org.abc.calc";
my $gwt_module  = "TaxCalc";
my $gwt_version = "2.5.1";

my @files = qw(
    .gitignore
    build.gradle
    src/main/resources/org/abc/calc/public/TaxCalc.html
    src/main/java/org/abc/calc/client/TaxCalc.java
    src/main/resources/org/abc/calc/public/TaxCalc.css
    src/main/java/org/abc/calc/TaxCalc.gwt.xml
    src/main/java/org/abc/calc/TaxCalcDev.gwt.xml
    src/main/webapp/index.html
    src/main/webapp/WEB-INF/web.xml
);

my $exp_gen_files = [];
foreach my $f (@files) {
    push @$exp_gen_files, ['A', $f];
}

my $gwt = CodeGen::GWT::Generator::GwtBoot->get_instance({
    base_dir     => $base_dir,
    project_dir  => $project_dir,
    root_package => $root_pkg,
    gwt_module   => $gwt_module,
    gwt_version  => $gwt_version,
});

$gwt->generate();
my $act_gen_files = $gwt->get_generated_list();
cmp_set($act_gen_files, $exp_gen_files, "Generated file list test");
foreach my $f (@files) {
    my $fp = catfile($base_dir, $project_dir, $f);
    ok(-f $fp, "Generated file existence test for $f");
}

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
