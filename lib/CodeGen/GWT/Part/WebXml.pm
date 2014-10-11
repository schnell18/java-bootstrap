package CodeGen::GWT::Part::WebXml;

use strict;
use warnings;
use CodeGen::Base::Part;
use CodeGen::Constants qw(:src_types);

our @ISA = qw(CodeGen::Base::Part);

sub get_type {
    my ($self) = @_;

    return SRC_TYPE_WEB;
}

sub get_web_sub_dir {
    return "WEB-INF";
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
