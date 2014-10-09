package CodeGen::Constants;

use strict;
use warnings;

# operation result
use constant RESULT_GENERATED     => 200;
use constant RESULT_UPDATED       => 210;
use constant RESULT_SKIP_EXISTING => 220;
use constant GIT_IGNORE              => "git_ignore";

# MyBatis part names
use constant MYBATIS_GIT_IGNORE              => "git_ignore";
use constant MYBATIS_GRADLE                  => "gradle";
use constant MYBATIS_MAPPER_INTERFACE        => "mapper_interface";
use constant MYBATIS_MAPPER_XML              => "mapper_xml";
use constant MYBATIS_MAPPER_UNIT_TEST_CLASS  => "mapper_unit_test_class";
use constant MYBATIS_MODEL_CLASS             => "model_class";
use constant MYBATIS_MYBATIS_CONFIG_XML      => "mybatis_config_xml";
use constant MYBATIS_MYBATIS_CONFIG_XML_UT   => "mybatis_config_xml_ut";
use constant MYBATIS_DB_CONFIG_PROPERTIES    => "db_config_properties";
use constant MYBATIS_DB_CONFIG_PROPERTIES_UT => "db_config_properties_ut";

# operation error
use constant ERR_TT_FAILURE       => 400;

# Misc
use constant EXISTS_SKIP             => 10;
use constant EXISTS_UPDATE           => 20;
use constant EXISTS_OVERWRITE        => 30;
use constant DEFAULT_MYBATIS_VERSION => "3.2.7";

require Exporter;
our @ISA = qw(Exporter);

our @EXPORT_OK = qw(
    RESULT_GENERATED
    RESULT_UPDATED
    RESULT_SKIP_EXISTING
    ERR_TT_FAILURE
    EXISTS_SKIP
    EXISTS_UPDATE
    EXISTS_OVERWRITE
    DEFAULT_MYBATIS_VERSION
    MYBATIS_GIT_IGNORE
    MYBATIS_GRADLE
    MYBATIS_MAPPER_INTERFACE
    MYBATIS_MAPPER_XML
    MYBATIS_MAPPER_UNIT_TEST_CLASS
    MYBATIS_MODEL_CLASS
    MYBATIS_MYBATIS_CONFIG_XML
    MYBATIS_MYBATIS_CONFIG_XML_UT
    MYBATIS_DB_CONFIG_PROPERTIES
    MYBATIS_DB_CONFIG_PROPERTIES_UT
);

our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
    results => [qw(
        RESULT_GENERATED
        RESULT_UPDATED
        RESULT_SKIP_EXISTING
        ERR_TT_FAILURE
    )],
    mybatis => [qw(
        MYBATIS_GIT_IGNORE
        MYBATIS_GRADLE
        MYBATIS_MAPPER_INTERFACE
        MYBATIS_MAPPER_XML
        MYBATIS_MAPPER_UNIT_TEST_CLASS
        MYBATIS_MODEL_CLASS
        MYBATIS_MYBATIS_CONFIG_XML
        MYBATIS_MYBATIS_CONFIG_XML_UT
        MYBATIS_DB_CONFIG_PROPERTIES
        MYBATIS_DB_CONFIG_PROPERTIES_UT
    )],
    misc => [qw(
        EXISTS_SKIP
        EXISTS_UPDATE
        EXISTS_OVERWRITE
        DEFAULT_MYBATIS_VERSION
    )],
);

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
