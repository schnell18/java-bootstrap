package CodeGen::MyBatis::Generator::MyBatis;

use strict;
use warnings;
use File::Basename;
use CodeGen::MyBatis::Component::MyBatisComponent;
use CodeGen::Base::Generator;
use CodeGen::MyBatis::Project;
use CodeGen::Constants qw(:misc :mybatis);
use CodeGen::Util qw(
    create_project_layout
    find_classpath_resource
    get_specs_from_file
);

our @ISA = qw(CodeGen::Base::Generator);

sub get_instance {
    my $class = shift;

    my ($config) = @_;
    return undef unless $config && ref($config) eq 'HASH';
    my $self = $class->SUPER::get_instance(@_);

    my $for_bootstrap      = $config->{bootstrap};
    my $spec_file          = $config->{spec_file};
    my $mybatis_ver        = $config->{mybatis_ver};
    my $root_package       = $config->{root_package};
    my $model_sub_package  = $config->{model_sub_package};
    my $mapper_sub_package = $config->{mapper_sub_package};
    my $project_dir        = $config->{project_dir};

    if ($for_bootstrap) {
        $self->set_bootstrap(1);
        if ($mybatis_ver) {
            $self->set_mybatis_ver($mybatis_ver);
        }
        else {
            $self->set_mybatis_ver(DEFAULT_MYBATIS_VERSION);
        }
        $self->set_root_package($root_package);
        $self->set_project_dir($project_dir);
    }

    $self->set_entity_spec_file($spec_file);
    $self->set_mapper_sub_package($mapper_sub_package);
    $self->set_model_sub_package($model_sub_package);

    return $self;
}

sub pre_generate {
    my ($self) = @_;

    my $root_package;
    my $root_pkg_path;
    if ($self->is_bootstrap()) {
        $root_package = $self->get_root_package();
        $root_pkg_path = $root_package;
        $root_pkg_path =~ s|\.|/|g;
    }
    else {
        my $file_pat = qr{mybatisConfig\.xml$|mybatisConfig-ut.xml$};
        (undef, $root_pkg_path) = find_classpath_resource(
            $self->get_base_dir(),
            $file_pat
        );
        $root_package = $root_pkg_path;
        $root_package =~ s|/|.|g;
    }
    # build the Project and Component objects
    my $project = CodeGen::MyBatis::Project->new();
    $project->set_mybatis_version($self->get_mybatis_ver());
    $project->set_root_package($root_package);
    $project->set_model_sub_package($self->get_model_sub_package());
    $project->set_mapper_sub_package($self->get_mapper_sub_package());
    my $spec_file = $self->get_entity_spec_file();
    if ($spec_file) {
        my $entities = get_specs_from_file($spec_file);
        foreach my $entity_name (keys(%$entities)) {
            my $component =
                CodeGen::MyBatis::Component::MyBatisComponent->new(
                    $project,
                    $entity_name
                );
            $component->set_attributes($entities->{$entity_name});
            $project->add_component($component);
        }

    }
    $self->set_project($project);
    if ($self->is_bootstrap()) {
        create_project_layout($self->get_project_dir(), $root_pkg_path);
        chdir($self->get_project_dir());
    }
}

sub get_entity_spec_file {
    return shift->_property("entity_spec_file");
}

sub set_entity_spec_file {
    my ($self, $entity_spec_file) = @_;

    return $self->_property("entity_spec_file", $entity_spec_file);
}

sub is_bootstrap {
    return shift->_property("bootstrap");
}

sub set_bootstrap {
    my ($self, $bootstrap) = @_;

    return $self->_property("bootstrap", $bootstrap);
}

sub get_mybatis_ver {
    return shift->_property("mybatis_ver");
}

sub set_mybatis_ver {
    my ($self, $mybatis_ver) = @_;

    return $self->_property("mybatis_ver", $mybatis_ver);
}

sub get_root_package {
    return shift->_property("root_package");
}

sub set_root_package {
    my ($self, $root_package) = @_;

    return $self->_property("root_package", $root_package);
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

sub get_project_dir {
    return shift->_property("project_dir");
}

sub set_project_dir {
    my ($self, $project_dir) = @_;

    return $self->_property("project_dir", $project_dir);
}

sub get_entities {
    return shift->_property("entities");
}

sub set_entities {
    my ($self, $entities) = @_;

    return $self->_property("entities", $entities);
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
