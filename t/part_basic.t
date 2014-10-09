#!/usr/bin/env perl

use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN {
    if (-d 't') {
        # running from the base directory
        unshift @INC, 'lib'
    }   
    else {
        unshift @INC, '../lib';
    }   
}

use CodeGen::Constants qw(:all);
use CodeGen::MyBatis::Project;
use CodeGen::MyBatis::Component::MyBatisComponent;

my $spec_file          = "";
my $root_pkg           = "org.abc.ibatis";
my $model_sub_pkg      = "shared.model";
my $mapper_sub_pkg     = "server.mapper";
my $root_pkg_dir       = $root_pkg;
my $model_sub_pkg_dir  = $model_sub_pkg;
my $mapper_sub_pkg_dir = $mapper_sub_pkg;
my $entity_name        = "Product";
my $attrs              = [ ];
my $project            = CodeGen::MyBatis::Project->new();

# convert package to directory
$root_pkg_dir =~ s|\.|/|g;
$model_sub_pkg_dir =~ s|\.|/|g;
$mapper_sub_pkg_dir =~ s|\.|/|g;

$project->set_mybatis_version("3.2.1");
$project->set_root_package($root_pkg);
$project->set_model_sub_package($model_sub_pkg);
$project->set_mapper_sub_package($mapper_sub_pkg);
my $component = CodeGen::MyBatis::Component::MyBatisComponent->new(
    $project,
    $entity_name
);
$component->set_attributes($attrs);
$project->add_component($component);


my $obj;
my $exp;
my $act;

$obj = $project->get_part(MYBATIS_DB_CONFIG_PROPERTIES);
# test 1: class base name
$exp = "DbConfigProperties";
$act = $obj->_get_class_base_name();
is($act, $exp, "class base name test 1");

# test 2: default base name
$exp = "dbConfig.properties";
$act = $obj->get_default_basename();
is($act, $exp, "default base name test 1");

# test 3: base name
$exp = "dbConfig.properties";
$act = $obj->get_basename();
is($act, $exp, "base name test 1");

# test 4: default template name
$exp = "CodeGen/MyBatis/Part/DbConfigProperties.tt2";
$act = $obj->get_default_template();
is($act, $exp, "default template test 1");

# test 5: template name
$exp = "CodeGen/MyBatis/Part/DbConfigProperties.tt2";
$act = $obj->get_template();
is($act, $exp, "template test 1");

# test 6: default artifact type
$exp = "resources";
$act = $obj->get_default_type();
is($act, $exp, "default artifact type test 1");


$obj = $project->get_part(MYBATIS_MYBATIS_CONFIG_XML);
# test 1: class base name
$exp = "MybatisConfigXml";
$act = $obj->_get_class_base_name();
is($act, $exp, "class base name test 2");

# test 2: default base name
$exp = "mybatisConfig.xml";
$act = $obj->get_default_basename();
is($act, $exp, "default base name test 2");

# test 3: default base name
$exp = "mybatisConfig.xml";
$act = $obj->get_basename();
is($act, $exp, "base name test 2");

# test 4: default template name
$exp = "CodeGen/MyBatis/Part/MybatisConfigXml.tt2";
$act = $obj->get_default_template();
is($act, $exp, "default template test 2");

# test 5: template name
$exp = "CodeGen/MyBatis/Part/MybatisConfigXml.tt2";
$act = $obj->get_template();
is($act, $exp, "template test 2");

# test 6: default artifact type
$exp = "resources";
$act = $obj->get_default_type();
is($act, $exp, "default artifact type test 2");

# test 7: output path
$exp = "src/main/resources/${root_pkg_dir}/mybatisConfig.xml";
$act = $obj->get_output();
is($act, $exp, "output path w/o root package test 2");

$obj = $component->get_part(MYBATIS_MAPPER_UNIT_TEST_CLASS);
# test 1: class base name
$exp = "MapperUnitTestClass";
$act = $obj->_get_class_base_name();
is($act, $exp, "class base name test 2");

# test 2: default base name
$exp = "FIXME";
$act = $obj->get_default_basename();
is($act, $exp, "default base name test 2");

# test 3: default base name
$exp = "ProductMapperTest.java";
$act = $obj->get_basename();
is($act, $exp, "base name test 3");

# test 4: default template name
$exp = "CodeGen/MyBatis/Part/MapperUnitTestClass.tt2";
$act = $obj->get_default_template();
is($act, $exp, "default template test 3");

# test 5: template name
$exp = "CodeGen/MyBatis/Part/MapperUnitTestClass.tt2";
$act = $obj->get_template();
is($act, $exp, "template test 3");

# test 6: default artifact type
$exp = "java";
$act = $obj->get_default_type();
is($act, $exp, "default artifact type test 3");

# test 7: output path
$exp = "src/test/java/${root_pkg_dir}/${mapper_sub_pkg_dir}/ProductMapperTest.java";
$act = $obj->get_output();
is($act, $exp, "output path w/o root package test 3");

# test 9: output path w/ explicit base name
$obj->set_basename("TestMyProductMapper.java");
$exp = "src/test/java/${root_pkg_dir}/${mapper_sub_pkg_dir}/TestMyProductMapper.java";
$act = $obj->get_output();
is($act, $exp, "output path w/ explicit basename test 3");

$obj = $project->get_part(MYBATIS_GIT_IGNORE);
# test 1: class base name
$exp = "GitIgnore";
$act = $obj->_get_class_base_name();
is($act, $exp, "class base name test 4");

# test 2: default base name
$exp = ".gitignore";
$act = $obj->get_default_basename();
is($act, $exp, "default base name test 4");

# test 3: base name
$exp = ".gitignore";
$act = $obj->get_basename();
is($act, $exp, "base name test 4");

# test 4: default template name
$exp = "CodeGen/MyBatis/Part/GitIgnore.tt2";
$act = $obj->get_default_template();
is($act, $exp, "default template test 4");

# test 5: template name
$exp = "CodeGen/MyBatis/Part/GitIgnore.tt2";
$act = $obj->get_template();
is($act, $exp, "template test 4");

# test 6: default artifact type
$exp = "FIXME";
$act = $obj->get_default_type();
is($act, $exp, "default artifact type test 4");

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
