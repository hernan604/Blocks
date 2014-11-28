use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blocks';
use Blocks::Controller::auth;

ok( request('/auth')->is_success, 'Request should succeed' );
done_testing();
