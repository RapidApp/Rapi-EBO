use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Rapi::EBO';
use Rapi::EBO::Controller::Img;

ok( request('/img')->is_success, 'Request should succeed' );
done_testing();
