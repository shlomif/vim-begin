#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

use 5.0016;

foreach my $fn (@ARGV)
{
    my $text = io($fn)->utf8->slurp;

    if ($text !~ s/\A-+\nlayout: *default\ntitle: *([^\n]+)\n-+\n+//ms)
    {
        die "Failed in $fn.";
    }
    my $title = $1;

    my $bp = '../' x scalar(() = $fn =~ m#/#g);

    io("$fn.tt2")->utf8->print(<<"EOF");
[%- PROCESS "blocks.tt2" -%]
[%- SET title = '$title' -%]
[%- SET base_path = '$bp' -%]
[%- PROCESS start_html -%]
$text

[% PROCESS "footer.tt2" %]
EOF
}
