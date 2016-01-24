use strict;
use warnings;

use Rapi::EBO;

my $app = Rapi::EBO->apply_default_middlewares(Rapi::EBO->psgi_app);
$app;

