package CodeGen::MyBatis::Part::SpringAppContextXml;

use strict;
use warnings;
use CodeGen::Base::Part;

our @ISA = qw(CodeGen::Base::Part);

sub get_basename {
    my ($self) = @_;

    return "app-ctx" . ($self->get_suffix() || "") . ".xml";
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
