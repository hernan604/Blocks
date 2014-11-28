use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blocks';
use Blocks::Controller::posts;

ok( request('/posts')->is_success, 'Request should succeed' );
done_testing();
