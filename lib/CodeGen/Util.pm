package CodeGen::Util;

use strict;
use warnings;
use File::Find;
use File::Basename;
use File::Path qw(make_path);
use File::Spec::Functions qw(catdir);
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw (
    create_project_layout
    get_specs_from_file
    find_classpath_resource
    find_append_pos_for
    to_snake_case
    get_template_prefix_dir
    get_template_include_dir
);

sub get_specs_from_file {
    my ($list) = @_;

    my %entities;

    my $fh;
    if ($list eq '-') {
        $fh = \*STDIN;
    }
    else {
        open($fh, "<", $list) or do {
            return;
        };
    }

    my $cur_tab;
    my $cur_attrs;
    while (my $ln = <$fh>) {
        chomp $ln;
        $ln =~ s/^\s+//;
        next if !$ln;

        if ($ln =~ /(\w+):$/) {
            $cur_tab = $1;
            $cur_attrs = [];
            $entities{$cur_tab} = $cur_attrs;
        }
        else {
            my ($attr, $type) = split(/\s+/, $ln);
            push @$cur_attrs, [$attr, $type];
        }
    }
    close($fh);

    return \%entities;
}

sub find_classpath_resource {
    my ($base_dir, $res_file_pat) = @_;

    my $res_file;
    find(
        sub {
            if (/$res_file_pat/) {
                $res_file = $File::Find::name;
            }
        },
        $base_dir
    );

    return "" unless $res_file;
    my $prefix_len = length('./src/main/resources/');
    return (
        substr($res_file, $prefix_len),
        substr(dirname($res_file), $prefix_len)
    );
}

sub find_append_pos_for {
    my ($lines, $tags) = @_;

    foreach my $tag (@$tags) {
        my $regex = qr{</$tag\b>|<$tag\b .*/>};
        for (my $i = (scalar(@$lines) - 1); $i >= 0; $i --) {
            return $i if $lines->[$i] =~ /$regex/;
        }
    }
    return 0;
}

sub to_snake_case {
    my ($name) = @_;

    my $low_beginnig = "";
    my $rest = $name;
    if ($name =~ /^([a-z]+)(.*)/) {
        $low_beginnig = $1;
        $rest = $2;
    }
    my @parts = $rest =~ /[A-Z](?:[A-Z]+|[a-z]*)(?=$|[A-Z])/g;
    foreach (@parts) {
        $_ = lc($_);
    }
    return join('_', $low_beginnig, @parts) if $low_beginnig;
    return join('_', @parts);
}

#TODO: fix this method to respect project directory layout
sub create_project_layout {
    my ($project_dir, $root_pkg_path) = @_;

    my @secs  = qw (main test);
    my @types = qw (java resources);
    
    foreach my $sec (@secs) {
        foreach my $type (@types) {
            my $dir = catdir(
                $project_dir,
                "src",
                $sec,
                $type,
                $root_pkg_path,
            );
            make_path($dir) unless -d $dir;
        }
    }
}

sub get_template_include_dir {

    my $fp = __FILE__;
    my @parts = split(/::/, __PACKAGE__);
    my $pkg_file = join('/', @parts) . '.pm';
    return substr($fp, 0, length($fp) - length($pkg_file));
}

sub get_template_prefix_dir {
    my ($pkg) = @_;

    my @parts = split(/::/, $pkg);
    my $len = scalar(@parts);
    return "" if ($len < 2);
    my @subs = @parts[0 .. ($len - 2)];
    return catdir(@subs);
}

1;

# vim: set ai nu nobk expandtab sw=4 ts=4 tw=72 syntax=perl :
