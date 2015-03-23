#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Blocks::Markdown;

my $blocks = Blocks::Markdown->new();

is( ref $blocks, 'Blocks::Markdown', "It is an object !" );

$blocks->resolve_block( \&resolve_test );

is ( ref $blocks->{ resolve }, 'CODE', "It is a sub!" );

is ( $blocks->{ resolve }( 1 ), "one", "Seems to resolve" );

done_testing();

sub resolve_test {
    my ( $id ) = @_;

    my %hash = ( 1,"one",2,"two",3, "three" );

    if ( exists $hash{ $id } ) {
        return $hash{ $id };
    }else{
        return undef;
    }
}

