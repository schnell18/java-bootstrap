package CodeGen::Constants;

use strict;
use warnings;

# operation result
use constant RESULT_GENERATED     => 200;
use constant RESULT_UPDATED       => 210;
use constant RESULT_SKIP_EXISTING => 220;

# source purpose
use constant SRC_MAIN => "main";
use constant SRC_TEST => "test";

# source type
use constant SRC_TYPE_JAVA     => "java";
use constant SRC_TYPE_RESOURCE => "resources";
use constant SRC_TYPE_WEB      => "webapp";
use constant SRC_TYPE_UNKNOWN  => "FIXME";

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

# GWT part names
use constant GWT_GIT_IGNORE     => "gwt_git_ignore";
use constant GWT_GRADLE         => "gwt_gradle";
use constant GWT_HOST_HTML      => "gwt_host_html";
use constant GWT_INDEX_HTML     => "gwt_index_html";
use constant GWT_MODULE_CLASS   => "gwt_module_class";
use constant GWT_MODULE_CSS     => "gwt_module_css";
use constant GWT_MODULE_XML     => "gwt_module_xml";
use constant GWT_MODULE_XML_DEV => "gwt_module_xml_dev";
use constant GWT_WEB_XML        => "gwt_web_xml";

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
    SRC_MAIN
    SRC_TEST
    SRC_TYPE_JAVA
    SRC_TYPE_RESOURCE
    SRC_TYPE_WEB
    SRC_TYPE_UNKNOWN
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
    GWT_GIT_IGNORE
    GWT_GRADLE
    GWT_HOST_HTML
    GWT_INDEX_HTML
    GWT_MODULE_CLASS
    GWT_MODULE_CSS
    GWT_MODULE_XML
    GWT_MODULE_XML_DEV
    GWT_WEB_XML
);

our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
    src_types => [qw(
        SRC_MAIN
        SRC_TEST
        SRC_TYPE_JAVA
        SRC_TYPE_RESOURCE
        SRC_TYPE_WEB
        SRC_TYPE_UNKNOWN
    )],
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
        GWT_GIT_IGNORE
        GWT_GRADLE
        GWT_HOST_HTML
        GWT_INDEX_HTML
        GWT_MODULE_CLASS
        GWT_MODULE_CSS
        GWT_MODULE_XML
        GWT_MODULE_XML_DEV
        GWT_WEB_XML
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
