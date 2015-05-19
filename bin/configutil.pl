#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use Catalyst qw/ConfigLoader/;
use Blocks;
use Template;

if ( -e $ARGV[0] ){

    my $filename = $ARGV[0];
    my $block = Blocks->config();
    my $template = Template->new();
    my $output;

    print Dumper $block;

    $template->process( $filename, { config =>  $block }, $filename . ".output" )
        or die "Error when processing the template $filename ". $template->error();
} else {
    die "Need to receive a valid file as argument";
}

