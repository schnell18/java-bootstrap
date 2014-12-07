package CodeGen::GWT::Component::RpcComponent;

use strict;
use warnings;
use CodeGen::Constants qw(:all);
use CodeGen::GWT::Part::Gradle;
use CodeGen::GWT::Part::WebXml;
use CodeGen::GWT::Part::GwtRpcServiceClass;
use CodeGen::GWT::Part::GwtRpcServiceAsyncClass;
use CodeGen::GWT::Part::GwtRpcServiceImplClass;
use CodeGen::Base::Component;

our @ISA = qw(CodeGen::Base::Component);

sub new {
    my $class = shift;

    my (undef, $name) = @_;
    my $self = $class->SUPER::new(@_);
    
    my $part;

    # gradle build script
    $part = CodeGen::GWT::Part::Gradle->new($self);
    $self->add_part(GWT_GRADLE, $part);

    $part = CodeGen::GWT::Part::GwtModuleXml->new($self);
    # GWT devmode does not seem work with separate xml and Java
    $self->add_part(GWT_MODULE_XML, $part);

    # service interface
    $part = CodeGen::GWT::Part::GwtRpcServiceClass->new($self);
    $self->add_part(GWT_RPC_SERVICE_CLASS, $part);

    # service async interface
    $part = CodeGen::GWT::Part::GwtRpcServiceAsyncClass->new($self);
    $self->add_part(GWT_RPC_SERVICE_ASYNC_CLASS, $part);

    # service implement
    $part = CodeGen::GWT::Part::GwtRpcServiceImplClass->new($self);
    $self->add_part(GWT_RPC_SERVICE_IMPL_CLASS, $part);

    return $self;
}

sub get_service_name {
    return shift->_property("service_name");
}

sub set_service_name {
    my ($self, $name) = @_;

    return $self->_property("service_name", $name);
}

sub service_impl_package {
    return shift->_property("service_impl_package");
}

sub get_service_impl_package {
    return shift->_property("service_impl_package");
}

sub set_service_impl_package {
    my ($self, $name) = @_;

    return $self->_property("service_impl_package", $name);
}

sub service_async_interface_package {
    return shift->_property("service_async_interface_package");
}

sub get_service_async_interface_package {
    return shift->_property("service_async_interface_package");
}

sub set_service_async_interface_package {
    my ($self, $name) = @_;

    return $self->_property("service_async_interface_package", $name);
}

sub service_interface_package {
    return shift->_property("service_interface_package");
}

sub get_service_interface_package {
    return shift->_property("service_interface_package");
}

sub set_service_interface_package {
    my ($self, $name) = @_;

    return $self->_property("service_interface_package", $name);
}

sub servlet_path_package {
    return shift->_property("servlet_path_package");
}

sub get_servlet_path_package {
    return shift->_property("servlet_path_package");
}

sub set_servlet_path_package {
    my ($self, $name) = @_;

    return $self->_property("servlet_path_package", $name);
}
#TODO: support GWT-RPC service methods generation

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
