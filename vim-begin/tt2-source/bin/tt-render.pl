#!/usr/bin/env perl

use strict;
use warnings;

use Template           ();
use File::Find::Object ();

use File::Path qw( mkpath );
use File::Spec ();
use File::Copy qw( copy );

my $template = Template->new(
    {
        INCLUDE_PATH => ".",
        POST_CHOMP   => 1,
        RELATIVE     => 1,
        ENCODING     => 'utf8',
    }
);

my $vars = {};

my $tree = File::Find::Object->new( {}, './src' );

while ( my $result = $tree->next_obj() )
{
    if ( $result->is_dir() )
    {
        mkpath(
            File::Spec->catdir(
                File::Spec->curdir(), "dest",
                @{ $result->full_components() }
            )
        );
    }
    else
    {
        my $basename = $result->basename;
        if ( $basename =~ s/\.html\.tt2\z/.html/ )
        {
            $vars->{base_path} =
                ( '../' x ( scalar( @{ $result->full_components } ) - 1 ) );
            $template->process(
                $result->path(),
                $vars,
                File::Spec->catfile(
                    File::Spec->curdir(),           "dest",
                    @{ $result->dir_components() }, $basename
                ),
                binmode => ':utf8',
            ) or die $template->error();
        }
        elsif (
            not(   ( $basename =~ /~\z/ )
                or ( $basename =~ /\A\./ )
                or ( $basename =~ /\.swp\z/ ) )
            )
        {
            copy(
                $result->path,
                File::Spec->catfile(
                    File::Spec->curdir(),           "dest",
                    @{ $result->dir_components() }, $basename
                ),
            );
        }
    }
}
