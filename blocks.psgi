use strict;
use warnings;

use Blocks;

my $app = Blocks->apply_default_middlewares(Blocks->psgi_app);
$app;

