package CodeGen::GWT::Component::UiBinderComponent;

use strict;
use warnings;
use CodeGen::Constants qw(:misc :mybatis);
use CodeGen::GWT::Part::GwtModuleXml;
use CodeGen::Base::Component;

our @ISA = qw(CodeGen::Base::Component);

sub new {
    my $class = shift;

    my (undef, $name) = @_;
    my $self = $class->SUPER::new(@_);
    
    my $part;

    # model class
    $part = CodeGen::GWT::Part::GwtModuleXml->new($self);
    $part->set_sub_package($self->get_model_sub_package());
    $part->set_basename("$name.java");
    $self->set_model_class($part);
    $self->add_part(MYBATIS_MODEL_CLASS, $part);

    return $self;
}

# defer initialization until first use
sub get_mapper_sub_pkg_path {
    my ($self) = @_;

    my $dir = $self->_property("mapper_sub_pkg_path"); 
    return $dir if $dir;

    my $sub_pkg = $self->get_mapper_sub_package(); 
    $sub_pkg =~ s|\.|/|g;
    $self->_property("mapper_sub_pkg_path", $sub_pkg); 
    return $sub_pkg;
}

# defer initialization until first use
sub get_model_sub_pkg_path {
    my ($self) = @_;

    my $dir = $self->_property("model_sub_pkg_path"); 
    return $dir if $dir;

    my $sub_pkg = $self->get_model_sub_package(); 
    $sub_pkg =~ s|\.|/|g;
    $self->_property("model_sub_pkg_path", $sub_pkg); 
    return $sub_pkg;
}

sub get_model_sub_package {
    my ($self) = @_;

    return $self->get_project()->get_model_sub_package();
}

sub get_mapper_sub_package {
    my ($self) = @_;

    return $self->get_project()->get_mapper_sub_package();
}

sub get_mapper_interface {
    return shift->_property(MYBATIS_MAPPER_INTERFACE);
}

sub set_mapper_interface {
    my ($self, $part) = @_;

    return $self->_property(MYBATIS_MAPPER_INTERFACE, $part);
}

sub get_mapper_xml {
    return shift->_property(MYBATIS_MAPPER_XML);
}

sub set_mapper_xml {
    my ($self, $part) = @_;

    return $self->_property(MYBATIS_MAPPER_XML, $part);
}
sub get_model_class {
    return shift->_property(MYBATIS_MODEL_CLASS);
}

sub set_model_class {
    my ($self, $part) = @_;

    return $self->_property(MYBATIS_MODEL_CLASS, $part);
}

sub get_mapper_unit_test_class {
    return shift->_property(MYBATIS_MAPPER_UNIT_TEST_CLASS);
}

sub set_mapper_unit_test_class {
    my ($self, $part) = @_;

    return $self->_property(MYBATIS_MAPPER_UNIT_TEST_CLASS, $part);
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
