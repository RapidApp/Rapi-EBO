#!/usr/bin/perl

use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Rapi::EBO::Model::DB;
my $db = Rapi::EBO::Model::DB->_one_off_connect;

my $Rs = $db->resultset('Color');

print $Rs->random_order->first->name . "\n";

