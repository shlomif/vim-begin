#!/usr/bin/perl

use strict;
use warnings;

use Template;
use File::Find::Object;

use File::Path qw( mkpath );
use File::Spec;
use File::Copy qw( copy );

my $template = Template->new(
    {
        INCLUDE_PATH => ".",
        POST_CHOMP => 1,
        RELATIVE => 1,
        ENCODING => 'utf8',
    }
);

my $vars = {};

my $tree = File::Find::Object->new({}, './src');

while (my $result = $tree->next_obj())
{
    if ($result->is_dir())
    {
        if ($result->path() eq './dest')
        {
            $tree->prune();
        }
        else
        {
            mkpath(File::Spec->catdir(
                    File::Spec->curdir(), "dest", @{$result->full_components()}
                )
            );
        }
    }
    else
    {
        my $basename = $result->basename;
        if ($basename =~ s/\.html\.tt2\z/.html/)
        {
            $template->process($result->path(), $vars,
                File::Spec->catfile(File::Spec->curdir(), "dest",
                    @{$result->dir_components()}, $basename),
                binmode => ':utf8',
            )
                or die $template->error();
        }
        elsif (
            $basename !~ /~\z/
            && ( !($basename =~ /\A\./ && $basename =~ /\.swp\z/) )
            && ($basename ne 'process.pl')
        )
        {
            copy($result->path,
                File::Spec->catfile(File::Spec->curdir(), "dest",
                    @{$result->dir_components()}, $basename),
            );
        }
    }
}
