#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use CodeGen::Version;
use CodeGen::MyBatis::Generator::MyBatis;

my $version = $CodeGen::Version::VERSION;
my @args = @ARGV;

my (
    $entity_spec_file,
    $model_sub_package,
    $mapper_sub_package,
    $help,
);
GetOptions(
    "model-sub-pkg=s"  => \$model_sub_package,
    "mapper-sub-pkg=s" => \$mapper_sub_package,
    "spec-file=s"      => \$entity_spec_file,
    "help"             => \$help,
) or do {
    usage();
    exit(1);
};

do {
    usage();
    exit(0);
} if $help || scalar(@args) == 0;

if (   $entity_spec_file
    && $entity_spec_file ne '-'
    && !-f $entity_spec_file) {
    printf "%s does not exist!", $entity_spec_file;
    exit(1);
}

my $mybatis = CodeGen::MyBatis::Generator::MyBatis->get_instance({
    base_dir           => '.',
    spec_file          => $entity_spec_file,
    model_sub_package  => $model_sub_package,
    mapper_sub_package => $mapper_sub_package,
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
MyBatis Bootstrap Tool -- Add data model and unit test ($version)
Usage:
  mybatis-add-model.pl --spec-file <entity attributes>
                       [--model-sub-pkg <sub package for model>]
                       [--mapper-sub-pkg <sub package for mapper>]
                       [--help]
Options:
  --spec-file       list entities and attributes/types to generate
  --model-sub-pkg   sub package of model class(default model)
  --mapper-sub-pkg  sub package of mapper class(default mapper)
  --help            show this help message
EOF
}

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
