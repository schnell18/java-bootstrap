package CodeGen::Base::Component;
# The component object is to manage to the parts and stash.

use strict;
use warnings;
use CodeGen::Constants qw(:all);

sub new {
    my $class = shift;

    my $project = shift;
    my $name = shift;
    my $self = { };
    bless $self, $class;
    $self->set_project($project);
    $self->set_name($name);
    return $self;
}

sub get_name {
    return shift->_property("name");
}

sub set_name {
    my ($self, $name) = @_;

    return $self->_property("name", $name);
}

sub get_project {
    return shift->_property("project");
}

sub set_project {
    my ($self, $project) = @_;

    return $self->_property("project", $project);
}

sub get_attributes {
    return shift->_property("attributes");
}

sub set_attributes {
    my ($self, $attributes) = @_;

    return $self->_property("attributes", $attributes);
}

sub get_root_package {
    my ($self) = @_;

    my $project = $self->get_project();
    return $project->get_root_package() if $project;
    return "";
}

sub get_base_dir {
    my ($self) = @_;
    
    my $generator = $self->get_generator();
    return unless $generator;
    return $generator->get_base_dir();
}

sub add_part {
    my ($self, $name, $part) = @_;

    return
        unless $part && $part->isa("CodeGen::Base::Part");

    my $arts = $self->_property("parts");
    if (!$arts) {
        $arts = {};
        $self->{__seq__} = 0;
        $self->_property("parts", $arts);
    }
    $self->{__seq__} ++;
    $part->set_sequence($self->{__seq__});
    $arts->{$name} = $part;
}

sub get_part {
    my ($self, $name) = @_;

    my $parts = shift->_property("parts");
    return undef unless $parts;
    return $parts->{$name};
}

sub get_parts {
    my ($self) = @_;

    my $parts = $self->_property("parts");
    return undef unless $parts;
    my @parts = sort { $a->get_sequence() <=> $b->get_sequence() }
                    values(%$parts);
    return \@parts;
}

sub set_parts {
    my ($self, $parts) = @_;

    return $self->_property("parts", $parts);
}

sub get_directory_by_purpose_and_type {
    my ($self, $purpose, $type) = @_;

    my $project = $self->get_project();
    if ($project) {
        return $project->get_directory_by_purpose_and_type(
            $purpose,
            $type
        );
    }
    else {
        return undef;
    }
}

sub _property {
    my ($self, $attr, $value) = @_; 

    if (defined($value)) {
        my $old_value = $self->{$attr};
        $self->{$attr} = $value;
        return $old_value;
    }   
    else {
        return $self->{$attr};
    }   
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
