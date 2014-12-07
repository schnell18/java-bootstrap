package CodeGen::GWT::Generator::GwtRpc;

use strict;
use warnings;
use File::Basename;
use CodeGen::Base::Generator;
use CodeGen::GWT::Project;
use CodeGen::Constants qw(:misc :mybatis);
use CodeGen::Util qw(
    find_classpath_resource
    get_specs_from_file
);

our @ISA = qw(CodeGen::Base::Generator);

sub get_instance {
    my $class = shift;

    my ($config) = @_;
    return undef unless $config && ref($config) eq 'HASH';
    my $self = $class->SUPER::get_instance(@_);

    my $gwt_version  = $config->{gwt_version};
    my $root_package = $config->{root_package};
    my $gwt_module   = $config->{gwt_module};

    $self->set_gwt_module($gwt_module);
    $self->set_gwt_version($gwt_version);
    $self->set_root_package($root_package);

    return $self;
}

sub pre_generate {
    my ($self) = @_;

    my $root_package;
    my $root_pkg_path;
    $root_package = $self->get_root_package();
    $root_pkg_path = $root_package;
    $root_pkg_path =~ s|\.|/|g;
    # build the Project and Component objects
    my $project = CodeGen::GWT::Project->new();
    $project->set_gwt_version($self->get_gwt_version());
    $project->set_root_package($root_package);
    $project->set_gwt_module($self->get_gwt_module());
    $self->set_project($project);
}

sub get_gwt_module {
    return shift->_property("gwt_module");
}

sub set_gwt_module {
    my ($self, $gwt_module) = @_;

    return $self->_property("gwt_module", $gwt_module);
}

sub get_gwt_version {
    return shift->_property("gwt_version");
}

sub set_gwt_version {
    my ($self, $gwt_version) = @_;

    return $self->_property("gwt_version", $gwt_version);
}

sub get_root_package {
    return shift->_property("root_package");
}

sub set_root_package {
    my ($self, $root_package) = @_;

    return $self->_property("root_package", $root_package);
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
