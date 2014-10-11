package CodeGen::GWT::Part::GwtHostHtml;

use strict;
use warnings;
use CodeGen::Constants qw(:all);
use CodeGen::Base::Part;
use CodeGen::Util qw(
    find_append_pos_for
);

our @ISA = qw(CodeGen::Base::Part);

sub update {
    my ($self) = @_;

    $self->add_type_alias();
    $self->add_mapper_inclusion();

    return RESULT_UPDATED;
}

sub add_mapper_inclusion {
    my ($self) = @_;

    $self->_load_file();

    my $file           = $self->get_abs_output();
    my $content        = $self->{__file_content__};
    my $parent         = $self->get_parent();
    my $mapper_xml_obj = $parent->get_part(MYBATIS_MAPPER_XML);
    my $target_pat     = $mapper_xml_obj->classpath_entry();

    # skip adding the new mapper if it is already present
    my $regex = qr/$target_pat/;
    my @exists = grep { /$regex/ } @$content;
    return 0 if @exists;

    my @tags = qw(
        mapper
        mappers
        databaseIdProvider
        environments
        plugins
        objectWrapperFactory
        objectFactory
        typeHandlers
        typeAliases
        settings
        properties
        configuration
    );

    my @mappers = grep { /<mappers/ } @$content;
    my $emit_parent_tag = scalar(@mappers) == 0;
    my $append_pos = find_append_pos_for($content, \@tags);
    
    open(my $fh, ">", $file) or die "Unable to open $file for write!\n";
    for (my $i = 0; $i < @$content; $i ++) {
        printf $fh "%s\n", $content->[$i];
        $self->emit_mapper($fh, $emit_parent_tag) if $i == $append_pos;
    }
    close $fh;
    return 1;
}

sub add_type_alias {
    my ($self) = @_;

    $self->_load_file();

    my $file            = $self->get_abs_output();
    my $content         = $self->{__file_content__};
    my $parent          = $self->get_parent();
    my $model_class_obj = $parent->get_part(MYBATIS_MODEL_CLASS);
    my $target_pat      = $model_class_obj->q_class_name();

    # skip adding the new type alias if it is already present
    my $regex = qr/$target_pat/;
    my @exists = grep { /$regex/ } @$content;
    return 0 if @exists;

    # find appropriate location to append <typeAlias> tag in this
    # order:
    #  1. the last typeAlias tag
    #  2. the last typeAliases tag
    #  3. the last settings tag
    #  4. the last properties tag
    #  5. the last configuration tag
    my @tags = qw(
        typeAlias
        typeAliases
        settings
        properties
        configuration
    );

    my @type_aliases = grep { /<typeAliases/ } @$content;
    my $emit_parent_tag = scalar(@type_aliases) == 0;
    my $append_pos = find_append_pos_for($content, \@tags);
    
    open(my $fh, ">", $file) or die "Unable to open $file for write!\n";
    for (my $i = 0; $i < @$content; $i ++) {
        printf $fh "%s\n", $content->[$i];
        $self->emit_type_alias($fh, $emit_parent_tag)
            if $i == $append_pos;
    }
    close $fh;
    return 1;
}

sub emit_mapper {
    my ($self, $fh, $emit_parent_tag) = @_;

    my $parent          = $self->get_parent();
    my $mapper_xml_obj  = $parent->get_part(MYBATIS_MAPPER_XML);
    my $mapper_xml_path = $mapper_xml_obj->classpath_entry();

    if ($emit_parent_tag) {
        print $fh <<EOF
  <mappers>
    <mapper resource="${mapper_xml_path}" />
  </mappers>
EOF
    }
    else {
        print $fh <<EOF
    <mapper resource="${mapper_xml_path}" />
EOF
    }
}

sub emit_type_alias {
    my ($self, $fh, $emit_parent_tag) = @_;

    my $parent           = $self->get_parent();
    my $model_class_obj  = $parent->get_part(MYBATIS_MODEL_CLASS);
    my $entity           = $parent->get_name();
    my $model_class_name = $model_class_obj->q_class_name();

    if ($emit_parent_tag) {
        print $fh <<EOF
  <typeAliases>
    <typeAlias alias="${entity}" type="${model_class_name}" />
  </typeAliases>
EOF
    }
    else {
        print $fh <<EOF
    <typeAlias alias="${entity}" type="${model_class_name}" />
EOF
    }
}

sub _load_file {
    my ($self) = @_;

    my $file = $self->get_abs_output();
    my @content = ();
    my $fh;
    open($fh, "<", $file) or die "Unable to open $file for read!\n";
    while(<$fh>) {
        chomp;
        push @content, $_;
    }
    close($fh);
    $self->{__file_content__} = \@content;
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
