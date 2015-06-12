use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blocks';
use Blocks::Controller::user;

ok( request('/user')->is_success, 'Request should succeed' );
done_testing();
