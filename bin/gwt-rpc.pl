#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use CodeGen::GWT::Generator::GwtRpc;
use CodeGen::Version;

my $version = $CodeGen::Version::VERSION;
my @args = @ARGV;

my (
    $sub_package,
    $service,
    $servlet_path,
    $help
);
GetOptions(
    "sub-package=s"  => \$sub_package,
    "service-name=s" => \$service,
    "servlet-path=s" => \$servlet_path,
    "help"           => \$help,
) or do {
    usage();
    exit(1);
};

do {
    usage();
    exit(0);
} if $help || scalar(@args) == 0;

die("You must specify the sub package using --sub-package!")
    unless $sub_package;
die("You must specify the name of service using --service-name!")
    unless $service;

my $gwt = CodeGen::GWT::Generator::GwtRpc->get_instance({
    base_dir     => '.',
    sub_package  => $sub_package,
    service_name => $service,
    servlet_path => $servlet_path,
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
GWT Bootstrap Tool -- create GWT-RPC skeleton files ($version)
Usage:
  gwt-rpc.pl --sub-package <sub package of service class>
             --service-name <name of service>
             [--servlet-path <servlet path component>]
             [--help]
Options:
  --sub-package    sub package of the widget (relative to root_pkg.client)
  --service-name   service name
  --servlet-path   the sub path under module context
  --help           show this help message
EOF
}

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
