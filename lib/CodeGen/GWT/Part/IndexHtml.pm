package CodeGen::GWT::Part::IndexHtml;

use strict;
use warnings;
use CodeGen::Constants qw(:src_types);
use CodeGen::Base::Part;

our @ISA = qw(CodeGen::Base::Part);

sub get_type {
    my ($self) = @_;

    return SRC_TYPE_WEB;
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
