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
use CodeGen::MyBatis::Generator::MyBatis;

# setup test directory
my $meta_dir = ".meta";
$meta_dir = -d $meta_dir ? rel2abs(".meta")
                         : rel2abs(catdir("t", ".meta"));
my $test_case = "tc1";
my $base_dir = tempdir('__CGXXXXXX', DIR => File::Spec->tmpdir());
my $project_dir = "abc";
# call setup script to initialize test repository and make commits
printf "Setting up test directory at %s\n", $base_dir;

my $root_pkg           = "org.abc.ibatis";
my $mybatis_version    = "3.2.6";

my @files = qw(
    .gitignore
    build.gradle
    src/main/resources/org/abc/ibatis/dbConfig.properties
    src/test/resources/org/abc/ibatis/dbConfig_ut.properties
    src/main/resources/org/abc/ibatis/mybatisConfig.xml
    src/test/resources/org/abc/ibatis/mybatisConfig_ut.xml
);

my $exp_gen_files = [];
foreach my $f (@files) {
    push @$exp_gen_files, ['A', $f];
}

my $mybatis = CodeGen::MyBatis::Generator::MyBatis->get_instance({
    base_dir           => $base_dir,
    bootstrap          => 1,
    no_spring          => 1,
    project_dir        => $project_dir,
    root_package       => $root_pkg,
    mybatis_ver        => $mybatis_version,
});

$mybatis->generate();
my $act_gen_files = $mybatis->get_generated_list();
cmp_set($act_gen_files, $exp_gen_files, "Generated file list test");
foreach my $f (@files) {
    my $fp = catfile($base_dir, $project_dir, $f);
    ok(-f $fp, "Generated file existence test for $f");
}
my $spec_file          = catfile($meta_dir, $test_case, "product.lst");
my $model_sub_pkg      = "shared.model";
my $mapper_sub_pkg     = "server.mapper";

my @product_files = qw(
    src/main/java/org/abc/ibatis/shared/model/Product.java
    src/main/java/org/abc/ibatis/server/mapper/ProductMapper.java
    src/main/resources/org/abc/ibatis/server/mapper/ProductMapper.xml
    src/test/java/org/abc/ibatis/server/mapper/ProductMapperTest.java
);

my @version_files = qw(
    src/main/java/org/abc/ibatis/shared/model/Version.java
    src/main/java/org/abc/ibatis/server/mapper/VersionMapper.java
    src/main/resources/org/abc/ibatis/server/mapper/VersionMapper.xml
    src/test/java/org/abc/ibatis/server/mapper/VersionMapperTest.java
);

my @mod_files = qw(
    src/main/resources/org/abc/ibatis/mybatisConfig.xml
    src/test/resources/org/abc/ibatis/mybatisConfig_ut.xml
);

$exp_gen_files = [];
foreach my $f (@product_files) {
    push @$exp_gen_files, ['A', $f];
}
foreach my $f (@mod_files) {
    push @$exp_gen_files, ['M', $f];
}
foreach my $f (@version_files) {
    push @$exp_gen_files, ['A', $f];
}
foreach my $f (@mod_files) {
    push @$exp_gen_files, ['M', $f];
}

$mybatis = CodeGen::MyBatis::Generator::MyBatis->get_instance({
    base_dir           => catfile($base_dir, $project_dir),
    no_spring          => 1,
    spec_file          => $spec_file,
    model_sub_package  => $model_sub_pkg,
    mapper_sub_package => $mapper_sub_pkg,
});

$mybatis->generate();
$act_gen_files = $mybatis->get_generated_list();
cmp_set($act_gen_files, $exp_gen_files, "Generated file list test");

foreach my $f (@product_files, @version_files, @mod_files) {
    my $fp = catfile($base_dir, $project_dir, $f);
    ok(-f $fp, "Generated file existence test for $f");
}

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
