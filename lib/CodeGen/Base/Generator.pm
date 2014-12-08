package CodeGen::Base::Generator;

use strict;
use warnings;
use File::Spec::Functions qw(catdir);
use Template;
use Template::Constants qw(:debug);
use CodeGen::Constants qw(:all);
use CodeGen::Util qw(get_template_include_dir);

sub get_instance {
    my ($class) = shift;

    my $config = shift;
    return undef unless $config && ref($config) eq 'HASH';

    my $include_path = get_template_include_dir(),
    my $project_dir  = $config->{project_dir};
    my $output_path  = $config->{base_dir};
    if ($project_dir) {
        $output_path = catdir($output_path, $project_dir);
    }

    my $tt = Template->new({
        DEBUG        => DEBUG_UNDEF,
        INCLUDE_PATH => $include_path,
        OUTPUT_PATH  => $output_path,
        EVAL_PERL    => 1,
    }) or die Template->error(), "\n"; #TODO: fix die() here

    my $self = { };
    bless $self, $class;

    $self->set_tt($tt);

    # set base directory
    $self->set_base_dir($output_path);

    return $self;
}

sub pre_generate {
    my ($self) = @_;

    # This method is meant to be overridden
    return;
}

sub generate {
    my ($self) = @_;

    my $stash = {};
    $self->pre_generate();
    my $project = $self->get_project();
    $stash->{project} = $project;
    my $parts = $project->get_parts();
    # generate project level parts
    $self->_generate_parts($stash, $parts);

    my $components = $project->get_components();
    return unless $components;
    # for each component: generate compoent level parts
    foreach my $component (@$components) {
        $stash->{comp} = $component;
        $parts = $component->get_parts();
        $self->_generate_parts($stash, $parts);
    }
    $self->post_generate();
}

sub post_generate {
    my ($self) = @_;

    # This method is meant to be overridden
    return;
}

sub get_base_dir {
    return shift->_property("base_dir");
}

sub set_base_dir {
    my ($self, $base_dir) = @_;

    return $self->_property("base_dir", $base_dir);
}

sub get_generated_list {
    return shift->_property("generated_list");
}

sub add_generated_item {
    my ($self, $gen_rec) = @_;

    my $gen_list = $self->get_generated_list();
    if (!$gen_list) {
        $gen_list = [];
        $self->_property("generated_list", $gen_list);
    }
    push @$gen_list, $gen_rec;
}

sub reset_generated_list {
    my ($self, $generated_list) = @_;

    $self->_property("generated_list", undef);
}

sub get_tt {
    return shift->_property("tt");
}

sub set_tt {
    my ($self, $tt) = @_;

    return $self->_property("tt", $tt);
}

sub get_project {
    return shift->_property("project");
}

sub set_project {
    my ($self, $project) = @_;

    if ($project) {
        $project->set_base_dir($self->get_base_dir());
    }
    return $self->_property("project", $project);
}

sub _generate_parts {
    my ($self, $stash, $parts) = @_;

    foreach my $part (@$parts) {
        my @ret = $self->_generate_part($stash, $part);
        if ($ret[0] == RESULT_GENERATED) {
            $self->add_generated_item(['A', $part->get_output()]);
        }
        elsif ($ret[0] == RESULT_UPDATED) {
            $self->add_generated_item(['M', $part->get_output()]);
        }
        elsif ($ret[0] == ERR_TT_FAILURE) {
            warn "Template Toolkit failure: " . $ret[1] . "\n";
        }
    }
}

sub _generate_part {
    my ($self, $stash, $part) = @_;

    my $fp = catdir($self->get_base_dir(), $part->get_output());
    my $action = $part->get_exists_action();
    if (-f $fp && $action == EXISTS_UPDATE) {
        return $part->update();
    }
    elsif (-f $fp && $action == EXISTS_SKIP) {
        return RESULT_SKIP_EXISTING;
    }

    # stash current part to make it available to template
    $stash->{part} = $part;

    my $tt = $self->get_tt();
    $tt->process(
        $part->get_template(),
        $stash,
        $part->get_output()
    ) or return (ERR_TT_FAILURE, $tt->error());
    return RESULT_GENERATED;
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
