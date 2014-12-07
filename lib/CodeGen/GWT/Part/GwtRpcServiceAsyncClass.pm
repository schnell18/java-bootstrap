package CodeGen::GWT::Part::GwtRpcSerivceAsyncClass;

use strict;
use warnings;
use CodeGen::Base::Part;

our @ISA = qw(CodeGen::Base::Part);

sub get_sub_package {
    my ($self) = @_;

    return $self->get_parent()->get_service_async_interface_package();
}

sub get_basename {
    my ($self) = @_;

    my $service_name = $self->get_parent()->get_service_name();
    return "${service_name}Async.java";
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
