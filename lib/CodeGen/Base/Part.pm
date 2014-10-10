package CodeGen::Base::Part;

use strict;
use warnings;
use Carp;
use File::Basename;
use File::Path qw(make_path);
use File::Spec::Functions qw(catdir catfile);
use CodeGen::Constants qw(:results :misc);
use CodeGen::Util qw(
    to_snake_case
    get_template_prefix_dir
);

sub new {
    my $class = shift;

    # validate parent type
    my $parent = shift;
    if ($parent && !($parent->isa("CodeGen::Base::Component")
                   ||$parent->isa("CodeGen::Base::Project"))) {
        confess(
            sprintf(
                "Wrong type, expect subclass of %s or %s\n",
                "CodeGen::Base::Component",
                "CodeGen::Base::Project"
            )
        );
    }

    my $self = { };
    bless $self, $class;
    $self->set_parent($parent) if $parent;
    return $self;
}

# get absolute path of output
sub get_abs_output {
    my ($self) = @_;

    my $parent = $self->get_parent();
    if ($parent) {
        return catdir($parent->get_base_dir(), $self->get_output());
    }
    else {
        return $self->get_output();
    }
}

sub get_output {
    my ($self) = @_;

    my $dir = $self->_property("output");
    return $self->get_default_output() unless $dir;
    return $dir;
}

sub set_output {
    my ($self, $output) = @_;

    return $self->_property("output", $output);
}

sub get_template {
    my ($self) = @_;

    my $template = $self->_property("template");
    return $self->get_default_template() unless $template;
    return $template;
}

sub set_template {
    my ($self, $template) = @_;

    return $self->_property("template", $template);
}

sub class_name {
    my ($self) = @_;

    return (split(/\./, $self->get_basename()))[0];
}

sub package_name {
    my ($self) = @_;

    return sprintf(
        "%s.%s",
        $self->get_root_package(),
        $self->get_sub_package(),
    );
}

sub q_class_name {
    my ($self) = @_;

    return sprintf(
        "%s.%s.%s",
        $self->get_root_package(),
        $self->get_sub_package(),
        $self->class_name()
    );
}

sub classpath_entry {
    my ($self) = @_;

    return catdir(
        $self->get_root_pkg_path(),
        $self->get_sub_pkg_path(),
        $self->get_basename()
    );

}

sub get_purpose {
    my ($self) = @_;

    my $purpose = $self->_property("purpose");
    return $self->get_default_purpose() unless $purpose;
    return $purpose;
}

sub set_purpose {
    my ($self, $purpose) = @_;

    return $self->_property("purpose", $purpose);
}

sub get_type {
    my ($self) = @_;

    my $type = $self->_property("type");
    return $self->get_default_type() unless $type;
    return $type;
}

sub set_type {
    my ($self, $type) = @_;

    return $self->_property("type", $type);
}

sub get_basename {
    my ($self) = @_;

    my $basename = $self->_property("basename");
    return $self->get_default_basename() unless $basename;
    return $basename;
}

sub set_basename {
    my ($self, $basename) = @_;

    return $self->_property("basename", $basename);
}

sub get_suffix {
    return shift->_property("suffix");
}

sub set_suffix {
    my ($self, $suffix) = @_;

    return $self->_property("suffix", $suffix);
}

sub is_top_level {
    return shift->_property("top_level");
}

sub set_top_level {
    my ($self, $top_level) = @_;

    return $self->_property("top_level", $top_level);
}

sub get_dir_prefix {
    my ($self) = @_;

    my $prefix = "";
    my $parent = $self->get_parent();
    if ($parent) {
        $prefix = $parent->get_directory_by_purpose_and_type(
            $self->get_purpose(),
            $self->get_type()
        );
    }
    return catdir(
        'src',
        $self->get_purpose(),
        $self->get_type()
    ) unless $prefix;
    return $prefix;
}

sub get_exists_action {
    my ($self) = @_;

    my $action = $self->_property("exists_action");
    return EXISTS_SKIP unless $action;
    return $action;
}

sub set_exists_action {
    my ($self, $exists_action) = @_;

    return $self->_property("exists_action", $exists_action);
}

sub get_root_pkg_path {
    my ($self) = @_;

    my $dir = $self->get_root_package();
    $dir =~ s|\.|/|g if $dir;
    return "" unless $dir;
    return $dir;
}

sub get_root_package {
    my ($self) = @_;

    my $parent = $self->get_parent();
    return $parent->get_root_package() if $parent;
    return "";
}

sub get_sub_pkg_path {
    my ($self) = @_;

    my $dir = $self->get_sub_package();
    $dir =~ s|\.|/|g if $dir;
    return "" unless $dir;
    return $dir;
}

sub get_sub_package {
    return shift->_property("sub_package");
}

sub set_sub_package {
    my ($self, $sub_package) = @_;

    return $self->_property("sub_package", $sub_package);
}

sub get_parent {
    return shift->_property("parent");
}

sub set_parent {
    my ($self, $parent) = @_;

    return $self->_property("parent", $parent);
}

sub get_sequence {
    return shift->_property("sequence");
}

sub set_sequence {
    my ($self, $sequence) = @_;

    return $self->_property("sequence", $sequence);
}

sub get_default_output {
    my ($self) = @_;

    if ($self->is_top_level()) {
        return $self->get_basename();
    }
    else {
       return catdir(
            $self->get_dir_prefix(),
            $self->classpath_entry()
        );
    }
}

sub get_default_basename {
    my ($self) = @_;

    # infer basename by artifact class name
    # infer type by artifact class name
    # by following these rules:
    # - GitIgnore is assigned base name ".gitignore"
    # - Gradle is assigned base name "build.gradle"
    # - *Xml -> *.xml
    # - *Properties -> *.properties
    # - otherwise, no default base name is assigned
    my $suffix = $self->get_suffix();
    $suffix = "" unless $suffix;
    my $base_name = $self->_get_class_base_name();
    if ($base_name eq "Gradle") {
        return "build${suffix}.gradle";
    }
    elsif ($base_name eq "GitIgnore") {
        return ".gitignore${suffix}";
    }
    elsif ($base_name =~ /(\w+)Xml/) {
        return "\l${1}${suffix}.xml";
    }
    elsif ($base_name =~ /(\w+)Properties/) {
        return "\l${1}${suffix}.properties";
    }
    else {
        return "FIXME";
    }
}

sub get_default_purpose {
    my ($self) = @_;

    # infer purpose by artifact class name
    # by following these rules:
    # - *TestClass is treated as test
    # - otherwise, main
    my $base_name = $self->_get_class_base_name();
    if ($base_name =~ /TestClass$/) {
        return 'test';
    }
    else {
        return 'main';
    }
}

sub get_default_type {
    my ($self) = @_;

    # infer type by artifact class name
    # by following these rules:
    # - *Xml and *Properties are treated as resources
    # - *Class and *Interface are treated as java
    # - otherwise, no default type is assigned (as indicated by 'FIXME')
    my $base_name = $self->_get_class_base_name();
    if ($base_name =~ /Class$|Interface$/) {
        return 'java';
    }
    elsif ($base_name =~ /Properties$|Xml$/) {
        return 'resources';
    }
    else {
        return 'FIXME';
    }
}

sub get_default_template {
    my ($self) = @_;

    my $template = $self->_property("_default_template");
    if (!$template) {
        my $prefix_dir = get_template_prefix_dir(ref($self));
        $template = $self->_get_class_base_name() . ".tt2";
        $template = catfile($prefix_dir, $template);
        $self->_property("_default_template", $template);
    }
    return $template;
}

sub _get_class_base_name {
    my ($self) = @_;

    my $class_base_name = $self->_property("_class_base_name");
    if (!$class_base_name) {
        my @comps = split(/::/, ref($self));
        $class_base_name = $comps[$#comps];
        $self->_property("_class_base_name", $class_base_name);
    }

    return $class_base_name;
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
