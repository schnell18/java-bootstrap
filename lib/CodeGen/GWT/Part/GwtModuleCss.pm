package CodeGen::GWT::Part::GwtModuleCss;

use strict;
use warnings;
use CodeGen::Base::Part;

our @ISA = qw(CodeGen::Base::Part);

sub get_sub_package {
    my ($self) = @_;

    return "public";
}

sub get_basename {
    my ($self) = @_;

    my $module_name = $self->get_parent()->get_gwt_module();
    return "${module_name}.css";
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
