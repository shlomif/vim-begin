#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;

use Path::Tiny qw/ cwd path tempdir tempfile /;

{
    my $fh      = cwd()->child("dest")->child(".htaccess");
    my $content = $fh->slurp_utf8();

    # TEST
    unlike( $content, qr#<html#ims, "dot-htaccess is not an html file", );
}
