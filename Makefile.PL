use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'CodeGen',
    AUTHOR           => q{Justin Zhang <schnell18@gmail.com>},
    VERSION_FROM     => 'lib/CodeGen/Version.pm',
    ABSTRACT         => 'Framework and tools to bootstrap Java project',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    EXE_FILES        => [
                         'bin/gwt-bootstrap.pl',
                         'bin/mybatis-add-model.pl',
                         'bin/mybatis-bootstrap.pl',
                        ],
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Template'  => 2.22,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'CodeGen-*' },
);
