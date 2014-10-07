package CodeGen::MyBatis::Project;
# The project object contains project wide information such as:
# - VCS ignore file
# - build script
# - layout
# - root package

use strict;
use warnings;
use File::Spec::Functions qw(catdir);
use CodeGen::Constants qw(:all);
use CodeGen::MyBatis::Part::GitIgnore;
use CodeGen::MyBatis::Part::Gradle;
use CodeGen::MyBatis::Part::DbConfigProperties;
use CodeGen::Base::Project;

our @ISA = qw(CodeGen::Base::Project);

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(@_); 

    my $part;

    # git ignore
    $part = CodeGen::MyBatis::Part::GitIgnore->new($self);
    $self->set_git_ignore($part);
    $self->add_part(MYBATIS_GIT_IGNORE, $part);

    # gradle build script
    $part = CodeGen::MyBatis::Part::Gradle->new($self);
    $self->set_gradle($part);
    $self->add_part(MYBATIS_GRADLE, $part);

    # prodcution dbConfigProperties
    $part = CodeGen::MyBatis::Part::DbConfigProperties->new($self);
    $self->add_part(MYBATIS_DB_CONFIG_PROPERTIES, $part);

    # unit test dbConfigProperties
    $part = CodeGen::MyBatis::Part::DbConfigProperties->new($self);
    $part->set_purpose('test');
    $part->set_suffix('_ut');
    $self->add_part(MYBATIS_DB_CONFIG_PROPERTIES_UT, $part);

    # production mybatis config
    $part = CodeGen::MyBatis::Part::MybatisConfigXml->new($self);
    $self->add_part(MYBATIS_MYBATIS_CONFIG_XML, $part);

    # unit test mybatis config
    $part = CodeGen::MyBatis::Part::MybatisConfigXml->new($self);
    $part->set_suffix('_ut');
    $part->set_purpose('test');
    $self->add_part(MYBATIS_MYBATIS_CONFIG_XML_UT, $part);

    return $self;
}


sub get_model_sub_package {
    my ($self) = @_;

    my $sub_pkg = $self->_property("model_sub_package"); 
    return "model" unless $sub_pkg;
    return $sub_pkg;
}

sub set_model_sub_package {
    my ($self, $model_sub_package) = @_;

    return $self->_property("model_sub_package", $model_sub_package);
}

sub get_mapper_sub_package {
    my ($self) = @_;

    my $sub_pkg = $self->_property("mapper_sub_package"); 
    return "mapper" unless $sub_pkg;
    return $sub_pkg;
}

sub set_mapper_sub_package {
    my ($self, $mapper_sub_package) = @_;

    return $self->_property("mapper_sub_package", $mapper_sub_package);
}

sub get_git_ignore {
    return shift->_property("git_ignore");
}

sub set_git_ignore {
    my ($self, $part) = @_;

    return $self->_property("git_ignore", $part);
}

sub get_gradle {
    return shift->_property("gradle");
}

sub set_gradle {
    my ($self, $part) = @_;

    return $self->_property("gradle", $part);
}

sub get_mybatis_version {
    my ($self) = @_;

    my $ver = $self->_property("mybatis_version");
    return $ver if $ver;
    return DEFAULT_MYBATIS_VERSION;
}

sub set_mybatis_version {
    my ($self, $mybatis_version) = @_;

    return $self->_property("mybatis_version", $mybatis_version);
}


1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
