package CodeGen::GWT::Part::GwtDevModuleXml;

use strict;
use warnings;
use CodeGen::Constants qw(:all);
use CodeGen::Base::Part;

our @ISA = qw(CodeGen::Base::Part);

sub get_basename {
    my ($self) = @_;

    my $dev_module_name = $self->get_parent()->get_dev_gwt_module();
    return "${dev_module_name}.gwt.xml";
}

sub get_type {
    my ($self) = @_;

    # Also place module xml into java directory
    return SRC_TYPE_JAVA;
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
