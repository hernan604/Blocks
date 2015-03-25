#!/usr/bin/perl

use strict;
use warnings;

use autodie;

use Text::Markdown 'markdown';

open my $fh, "<", $ARGV[0];
    my $file = join "", <$fh>;
    print $file;
    print "\n---\n";
    print markdown $file;
close $fh;
