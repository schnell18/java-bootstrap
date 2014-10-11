#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use CodeGen::GWT::Generator::GWTBoot;

my $version = $CodeGen::Version::VERSION;
my @args = @ARGV;

my (
    $project_dir,
    $root_package,
    $help,
    $gwt_module,
    $gwt_version
);
GetOptions(
    "project-dir=s"  => \$project_dir,
    "root-package=s" => \$root_package,
    "gwt-module=s"   => \$gwt_module,
    "gwt-version=s"  => \$gwt_version,
    "help"           => \$help,
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
die("You must specify GWT module name using --gwt-module!")
    unless $gwt_module;


my $gwt = CodeGen::GWT::Generator::GwtBoot->get_instance({
    base_dir           => '.',
    project_dir        => $project_dir,
    root_package       => $root_package,
    gwt_module         => $gwt_module,
    gwt_version        => $gwt_version,
});

$gwt->generate();
my $gen_files = $gwt->get_generated_list();
if ($gen_files && @$gen_files) {
    printf "Generated files:\n";
    foreach my $f (@$gen_files) {
        printf "%s    %s\n", $f->[0], $f->[1];
    }
}

sub usage {

    print <<EOF;
GWT Bootstrap Tool -- initialize project layout ($version)
Usage:
  gwt-bootstrap.pl --project-dir <project root directory>
                   --root-package <root package>
                   --gwt-module <gwt module name>
                   [--gwt-version <GWT version to use>]
                   [--help]
Options:
  --project-dir     root directory of the GWT project
  --root-package    root package of the GWT project
  --gwt-module      name of the GWT module
  --gwt-version     GWT version to use(default 2.6.1)
  --help            show this help message
EOF
}

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
