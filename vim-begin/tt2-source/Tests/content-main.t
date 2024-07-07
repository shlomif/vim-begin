#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;

use Path::Tiny qw/ cwd path tempdir tempfile /;

{
    my $fh      = cwd()->child("dest")->child(".htaccess");
    my $content = $fh->slurp_utf8();

    # TEST
    unlike( $content, qr#<html#ims, "dot-htaccess is not an html file", );
}

{
    my $fh      = cwd()->child("dest")->child( "css", "style.css" );
    my $content = $fh->slurp_utf8();

    # TEST
    cmp_ok( length($content), '>', 200, "style.css is long enough", );
}
