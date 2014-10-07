package CodeGen::Base::Project;
# The project object contains project wide information such as:
# - VCS ignore file
# - build script
# - layout
# - root package
# - components

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = { };
    bless $self, $class;
    return $self;
}

sub get_layout {
    return shift->_property("layout");
}

sub set_layout {
    my ($self, $part) = @_;

    return $self->_property("layout", $part);
}

sub get_root_package {
    return shift->_property("root_package");
}

sub set_root_package {
    my ($self, $part) = @_;

    return $self->_property("root_package", $part);
}

sub get_base_dir {
    return shift->_property("base_dir");
}

sub set_base_dir {
    my ($self, $part) = @_;

    return $self->_property("base_dir", $part);
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

sub add_component {
    my ($self, $component) = @_;

    return
        unless $component && $component->isa("CodeGen::Base::Component");

    my $arts = $self->_property("components");
    if (!$arts) {
        $arts = [];
        $self->_property("components", $arts);
    }
    push @$arts, $component;
}

sub get_component {
    my ($self, $index) = @_;

    my $components = shift->_property("components");
    return undef unless $components;
    if ($index < scalar(@$components)) {
        return $components->[$index];
    }
    else {
        return undef;
    }
}

sub get_components {
    my ($self) = @_;

    return $self->_property("components");
}

sub get_directory_by_purpose_and_type {
    my ($self, $purpose, $type) = @_;

    my $layout = $self->get_layout();
    if ($layout) {
        return $layout->get_directory_by_purpose_and_type(
            $purpose,
            $type
        );
    }
    else {
        #TODO: implement directory layout here later
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
