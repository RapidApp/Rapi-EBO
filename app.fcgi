#!/usr/bin/env perl

use strict;
use warnings;

use FindBin '$Bin';

use Plack::Util;
use Plack::Handler::FCGI;

my $app = Plack::Util::load_psgi("$Bin/app.psgi");

my $server = Plack::Handler::FCGI->new();
$server->run($app);