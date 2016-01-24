#!/usr/bin/perl

use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Path::Class qw(file dir);
use RapidApp::Util ':all';

use Rapi::EBO::Scrape;


my $File = file( $ARGV[0] )->resolve;
my $content = $File->slurp;

my $Scrape = Rapi::EBO::Scrape->new({ html => $content });

scream({
  Data => $Scrape->Data,
  timestamp => $Scrape->timestamp
});

