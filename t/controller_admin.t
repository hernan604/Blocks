use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blocks';
use Blocks::Controller::admin;

ok( request('/admin')->is_success, 'Request should succeed' );
done_testing();
