#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use_ok( 'Blocks::Parse', 'bparams' );

is(
        bparams( "1" ),
        1,
        "process only the id",
);


is(
        bparams( "1\n\n2\n"),
        1,
        "ignores all except the first line",
);

is(
        bparams( "1,2,3" ),
        [ 1,2,3 ],
        "Returns a arrayref with list with the blocks selected",
);

is(
        bparams( "last 10" ),
        undef,
        "Not implemented",
);

done_testing;
__END__





