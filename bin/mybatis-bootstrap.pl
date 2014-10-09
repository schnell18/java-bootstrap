#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use File::Spec::Functions qw(catdir);
use CodeGen::MyBatis::Generator::MyBatis;

my @args = @ARGV;

my (
    $project_dir,
    $root_package,
    $model_sub_package,
    $mapper_sub_package,
    $entity_spec_file,
    $help,
    $version
);
GetOptions(
    "project-dir=s"     => \$project_dir,
    "root-package=s"    => \$root_package,
    "model-sub-pkg=s"   => \$model_sub_package,
    "mapper-sub-pkg=s"  => \$mapper_sub_package,
    "spec-file=s"       => \$entity_spec_file,
    "mybatis-version=s" => \$version,
    "help"              => \$help,
) or do {
    usage();
    exit(1);
};

do {
    usage();
    exit(0);
} if $help || scalar(@args) == 0;


die("You must specify project root directory using --project-dir!")
    unless $project_dir;
die("You must specify root package using --root-package!")
    unless $root_package;

if (   $entity_spec_file
    && $entity_spec_file ne '-'
    && !-f $entity_spec_file) {
    printf "%s does not exist!", $entity_spec_file;
    exit(1);
}

my $mybatis = CodeGen::MyBatis::Generator::MyBatis->get_instance({
    base_dir           => '.',
    include_path       => catdir($Bin, 'templates'),
    spec_file          => $entity_spec_file,
    bootstrap          => 1,
    project_dir        => $project_dir,
    root_package       => $root_package,
    model_sub_package  => $model_sub_package,
    mapper_sub_package => $mapper_sub_package,
    mybatis_ver        => $version,
});

$mybatis->generate();
my $gen_files = $mybatis->get_generated_list();
if ($gen_files && @$gen_files) {
    printf "Generated files:\n";
    foreach my $f (@$gen_files) {
        printf "%s    %s\n", $f->[0], $f->[1];
    }
}

sub usage {

    print <<EOF;
MyBatis Bootstrap Tool -- initialize project layout
Usage:
  mybatis-bootstrap.pl --project-dir <project root directory>
                       --root-package <root package>
                       [--model-sub-pkg <sub package for model>]
                       [--mapper-sub-pkg <sub package for mapper>]
                       [--spec-file <entity attributes>]
                       [--mybatis-version <MyBatis version to use>]
                       [--help]
Options:
  --project-dir     root directory of the MyBatis project
  --root-package    root package of the MyBatis project
  --model-sub-pkg   sub package of model class(default model)
  --mapper-sub-pkg  sub package of mapper class(default mapper)
  --spec-file       attributes and types of the entity
  --mybatis-version MyBatis version to use(default 3.2.7)
  --help            show this help message
EOF
}

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
