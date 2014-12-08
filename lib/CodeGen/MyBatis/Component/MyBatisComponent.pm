package CodeGen::MyBatis::Component::MyBatisComponent;
# The Component object is to add one or more MyBatis models in existing
# project.

use strict;
use warnings;
use CodeGen::Constants qw(:misc :mybatis);
use CodeGen::Base::Component;
use CodeGen::MyBatis::Part::MybatisConfigXml;
use CodeGen::MyBatis::Part::ModelClass;
use CodeGen::MyBatis::Part::MapperInterface;
use CodeGen::MyBatis::Part::MapperXml;
use CodeGen::MyBatis::Part::MapperUnitTestClass;

our @ISA = qw(CodeGen::Base::Component);

sub new {
    my $class = shift;

    my (undef, $name) = @_;
    my $self = $class->SUPER::new(@_);

    my $part;

    # model class
    $part = CodeGen::MyBatis::Part::ModelClass->new($self);
    $part->set_sub_package($self->get_model_sub_package());
    $part->set_basename("$name.java");
    $self->set_model_class($part);
    $self->add_part(MYBATIS_MODEL_CLASS, $part);

    # mapper interface
    $part = CodeGen::MyBatis::Part::MapperInterface->new($self);
    $part->set_sub_package($self->get_mapper_sub_package());
    $part->set_basename("${name}Mapper.java");
    $self->set_model_class($part);
    $self->set_mapper_interface($part);
    $self->add_part(MYBATIS_MAPPER_INTERFACE, $part);

    # mapper xml
    $part = CodeGen::MyBatis::Part::MapperXml->new($self);
    $part->set_sub_package($self->get_mapper_sub_package());
    $part->set_basename("${name}Mapper.xml");
    $self->set_mapper_xml($part);
    $self->add_part(MYBATIS_MAPPER_XML, $part);

    # get if spring integration is disabled
    my $no_spring = $self->get_project()->get_no_spring();
    # mapper unit test
    $part = CodeGen::MyBatis::Part::MapperUnitTestClass->new($self);
    $part->set_no_spring($no_spring);
    $part->set_sub_package($self->get_mapper_sub_package());
    $part->set_basename("${name}MapperTest.java");
    $self->set_mapper_unit_test_class($part);
    $self->add_part(MYBATIS_MAPPER_UNIT_TEST_CLASS, $part);

    # with spring integration typeAlias and mapper xml inclusion
    # is no longer necessary
    if ($no_spring) {
        # production mybatis config
        $part = CodeGen::MyBatis::Part::MybatisConfigXml->new($self);
        $part->set_exists_action(EXISTS_UPDATE);
        $self->add_part(MYBATIS_MYBATIS_CONFIG_XML, $part);

        # unit test mybatis config
        $part = CodeGen::MyBatis::Part::MybatisConfigXml->new($self);
        $part->set_exists_action(EXISTS_UPDATE);
        $part->set_suffix('_ut');
        $part->set_purpose('test');
        $self->add_part(MYBATIS_MYBATIS_CONFIG_XML_UT, $part);
    }

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
