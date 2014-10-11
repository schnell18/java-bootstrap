package CodeGen::GWT::Project;
# The project object contains project wide information such as:
# - VCS ignore file
# - build script
# - layout
# - root package

use strict;
use warnings;
use File::Spec::Functions qw(catdir);
use CodeGen::Constants qw(:all);
use CodeGen::GWT::Part::GitIgnore;
use CodeGen::GWT::Part::Gradle;
use CodeGen::GWT::Part::GwtHostHtml;
use CodeGen::GWT::Part::GwtModuleClass;
use CodeGen::GWT::Part::GwtModuleCss;
use CodeGen::GWT::Part::GwtModuleXml;
use CodeGen::GWT::Part::GwtDevModuleXml;
use CodeGen::GWT::Part::IndexHtml;
use CodeGen::GWT::Part::WebXml;

use CodeGen::Base::Project;

our @ISA = qw(CodeGen::Base::Project);

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(@_); 

    my $part;

    # git ignore
    $part = CodeGen::GWT::Part::GitIgnore->new($self);
    $self->add_part(GWT_GIT_IGNORE, $part);

    # gradle build script
    $part = CodeGen::GWT::Part::Gradle->new($self);
    $self->add_part(GWT_GRADLE, $part);

    $part = CodeGen::GWT::Part::GwtHostHtml->new($self);
    $self->add_part(GWT_HOST_HTML, $part);

    $part = CodeGen::GWT::Part::GwtModuleClass->new($self);
    $self->add_part(GWT_MODULE_CLASS, $part);

    $part = CodeGen::GWT::Part::GwtModuleCss->new($self);
    $self->add_part(GWT_MODULE_CSS, $part);

    $part = CodeGen::GWT::Part::GwtModuleXml->new($self);
    # GWT devmode does not seem work with separate xml and Java
    $self->add_part(GWT_MODULE_XML, $part);

    $part = CodeGen::GWT::Part::GwtDevModuleXml->new($self);
    $self->add_part(GWT_MODULE_XML_DEV, $part);

    $part = CodeGen::GWT::Part::IndexHtml->new($self);
    $self->add_part(GWT_INDEX_HTML, $part);

    $part = CodeGen::GWT::Part::WebXml->new($self);
    $self->add_part(GWT_WEB_XML, $part);

    return $self;
}

sub q_module_name {
    my ($self) = @_;

    return sprintf(
        "%s.%s",
        $self->get_root_package(),
        $self->get_gwt_module()
    );
}

sub q_dev_module_name {
    my ($self) = @_;

    return sprintf(
        "%s.%sDev",
        $self->get_root_package(),
        $self->get_gwt_module()
    );
}

sub gwt_version {
    my ($self) = @_;
    return $self->get_gwt_version();
}

sub gwt_module {
    my ($self) = @_;
    return $self->get_gwt_module();
}

sub get_gwt_version {
    my ($self) = @_;

    my $ver = $self->_property("gwt_version");
    return $ver if $ver;
    return DEFAULT_GWT_VERSION;
}

sub set_gwt_version {
    my ($self, $gwt_version) = @_;

    return $self->_property("gwt_version", $gwt_version);
}

sub get_dev_gwt_module {

    my $base = shift->_property("gwt_module") || "";
    return $base . "Dev";
}

sub get_gwt_module {
    return shift->_property("gwt_module");
}

sub set_gwt_module {
    my ($self, $gwt_module) = @_;

    return $self->_property("gwt_module", $gwt_module);
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
