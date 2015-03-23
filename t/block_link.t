#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use_ok( 'Blocks::Markdown', 'markdown', 'blocks' );

# link with block 01

my $test1 = <<EOF;

<blocks_cms>1</blocks_cms>

EOF

my $expected1 = <<EOF;


EOF

is(
    blocks( $test1 ),
    $expected1,
    "Basic substition"
);

my $test2 = <<EOF;
This is a test
==============

Kind of
-------

A markdown engine, that should be able to include blocks
from other places inside this markdown

Syntax:
<blocks_cms></blocks_cms>

* More Markdown
* Seems to be items

EOF

my $expected2 = <<EOF;
This is a test
==============

Kind of
-------

A markdown engine, that should be able to include blocks
from other places inside this markdown

Syntax:

* More Markdown
* Seems to be items

EOF

is(
    blocks( $test2 ),
    $expected2,
    "Basic substition with Full Markdown"
);

done_testing;
