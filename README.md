# Introduction
[![Build Status](https://travis-ci.org/schnell18/java-bootstrap.svg?branch=master)](https://travis-ci.org/schnell18/java-bootstrap)
This project provides a framework to develop bootstrap and incremental
tools for Java project using various technologies such as:

- GWT (UiBinder, GWT-RPC, RequestFactory)
- MyBatis

The purpose of this project to make people who are comfortable to use
command line to jump start a Java project without typical copy-paste and
ammend approach which also tends to duplicate the error of previous
project. The design philosophy centers on:

- minimalism approach
- start from scratch
- work out-of-box

The generated artifacts are complete with dependencies resolved and the
programs should compile and even pass the unit test. Anything generated
is absolutely necessary. User does not have to delete useless files as
they bootstrap a project by copying a similar one.

# Usage
## mybatis-bootstrap
This is command line tool to create a MyBatis project from scratch.
Below is the usage description:

    MyBatis Bootstrap Tool -- initialize project layout
    Usage:
      mybatis-bootstrap.pl --project-dir <project root directory>
                           --root-package <root package>
                           [--model-sub-pkg <sub package for model>]
                           [--mapper-sub-pkg <sub package for mapper>]
                           [--spec-file <entity attributes>]
                           [--mybatis-version <MyBatis version to use>]
                           [--help]
    Options:
      --project-dir     root directory of the MyBatis project
      --root-package    root package of the MyBatis project
      --model-sub-pkg   sub package of model class(default model)
      --mapper-sub-pkg  sub package of mapper class(default mapper)
      --spec-file       attributes and types of the entity
      --mybatis-version MyBatis version to use(default 3.2.7)
      --help            show this help message

Here is a typical usage example:

    mybatis-bootstrap.pl --project-dir ggg --root-package org.xyz.mybatisdemo
    Generated files:
    A    .gitignore
    A    build.gradle
    A    src/main/resources/org/xyz/mybatisdemo/dbConfig.properties
    A    src/test/resources/org/xyz/mybatisdemo/dbConfig_ut.properties
    A    src/main/resources/org/xyz/mybatisdemo/mybatisConfig.xml
    A    src/test/resources/org/xyz/mybatisdemo/mybatisConfig_ut.xml

## mybatis-add-model
This is command line tool to create one or more MyBatis model within
existing project. This line tool should run in the top level project
directory. It generates:
- POJO Model class
- MyBatis mapper interface
- MyBatis mapper xml
- MyBatis mapper unit test sketelon
It also updates the mybatisConfig.xml to register type alias and
mapper xml file.

Below is the usage description:

    MyBatis Bootstrap Tool -- Add data model class and unit test
    Usage:
      mybatis-add-model.pl --spec-file <entity attributes>
                           [--model-sub-pkg <sub package for model>]
                           [--mapper-sub-pkg <sub package for mapper>]
                           [--help]
    Options:
      --spec-file       list entities and attributes/types to generate
      --model-sub-pkg   sub package of model class(default model)
      --mapper-sub-pkg  sub package of mapper class(default mapper)
      --help            show this help messag

Typical usage example:

    mybatis-add-model.pl --spec-file ../product.lst --model-sub-pkg shared.model --mapper-sub-pkg server.mapper
    Generated files:
    A    src/main/java/org/xyz/mybatisdemo/shared/model/Product.java
    A    src/main/java/org/xyz/mybatisdemo/server/mapper/ProductMapper.java
    A    src/main/resources/org/xyz/mybatisdemo/server/mapper/ProductMapper.xml
    A    src/test/java/org/xyz/mybatisdemo/server/mapper/ProductMapperTest.java
    M    src/main/resources/org/xyz/mybatisdemo/mybatisConfig.xml
    M    src/test/resources/org/xyz/mybatisdemo/mybatisConfig_ut.xml
    A    src/main/java/org/xyz/mybatisdemo/shared/model/Version.java
    A    src/main/java/org/xyz/mybatisdemo/server/mapper/VersionMapper.java
    A    src/main/resources/org/xyz/mybatisdemo/server/mapper/VersionMapper.xml
    A    src/test/java/org/xyz/mybatisdemo/server/mapper/VersionMapperTest.java
    M    src/main/resources/org/xyz/mybatisdemo/mybatisConfig.xml
    M    src/test/resources/org/xyz/mybatisdemo/mybatisConfig_ut.xml


# Build and install
This project use ExtUtils::MakeMaker to build and install. The execute
script will be installed into the bin directory of Perl installation.
The command to build and install this tool is:

    perl Makefile.PL
    make
    make test
    make install


# TODOs:
## Core
- create document for develop, build and use of the tools
- create rpm spec file
- support directory layout other than Gradle/Maven default
- support build tool other than Gradle

## MyBatis
- support mapper find methods
- add more unit tests to better cover the generation code

## GWT
- convert quick-and-dirty GWT scripts to use this framework
