#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;

use Path::Tiny qw/ cwd path tempdir tempfile /;

my $DEST_DIR = cwd()->child("dest");

{
    my $fh      = $DEST_DIR->child(".htaccess");
    my $content = $fh->slurp_utf8();

    # TEST
    unlike( $content, qr#<html#ims, "dot-htaccess is not an html file", );
}

{
    my $fh      = $DEST_DIR->child( "css", "style.css" );
    my $content = $fh->slurp_utf8();

    # TEST
    cmp_ok( length($content), '>', 200, "style.css is long enough", );
}
