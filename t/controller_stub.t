use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blocks';
use Blocks::Controller::stub;

ok( request('/stub')->is_success, 'Request should succeed' );
done_testing();
