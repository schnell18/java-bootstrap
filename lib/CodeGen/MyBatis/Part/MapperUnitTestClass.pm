package CodeGen::MyBatis::Part::MapperUnitTestClass;

use strict;
use warnings;
use File::Spec::Functions qw(catdir catfile);
use CodeGen::Util qw(get_template_prefix_dir);
use CodeGen::Base::Part;

our @ISA = qw(CodeGen::Base::Part);

sub get_template {
    my ($self) = @_;

    my $template = $self->get_default_template();
    do {
        my $prefix_dir = get_template_prefix_dir(ref($self));
        $template = $self->_get_class_base_name() . "Spring.tt2";
        $template = catfile($prefix_dir, $template);
    } unless $self->get_no_spring();
    return $template;
}

sub get_no_spring {
    return shift->_property("no_spring");
}

sub set_no_spring {
    my ($self, $no_spring) = @_;

    return $self->_property("no_spring", $no_spring);
}
1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
