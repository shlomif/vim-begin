package Shlomif::Spelling::FindFiles;

use strict;
use warnings;

use Moo;
use List::Util 1.34 qw/ any /;

use HTML::Spelling::Site::Finder ();

my @prunes = ( qr#tutorials/getting-started-with-vim#, );

sub list_htmls
{
    my ($self) = @_;

    return HTML::Spelling::Site::Finder->new(
        {
            root_dir => 'dest',
            prune_cb => sub {
                my ($path) = @_;
                return any { $path =~ $_ } @prunes;
            },
        }
    )->list_all_htmls;
}

1;
