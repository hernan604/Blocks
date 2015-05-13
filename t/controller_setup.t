use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blocks';
use Blocks::Controller::setup;

ok( request('/setup')->is_success, 'Request should succeed' );
done_testing();
