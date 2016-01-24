#!/usr/bin/perl

use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Rapi::EBO::Scrape;

use Rapi::EBO::Model::DB;
my $db = Rapi::EBO::Model::DB->_one_off_connect;
my $datasetRs   = $db->resultset('Dataset');
my $candidateRs = $db->resultset('Candidate');

use Path::Class qw(file dir);
use RapidApp::Util ':all';

my $Dir = dir( $ARGV[0] )->resolve;

for my $File ( $Dir->children ) {

  print "\n[$File]\n";

  my $content = $File->slurp;
  
  my $Scrape = Rapi::EBO::Scrape->new({ html => $content });
  
  my $timestamp = $Scrape->timestamp;
  
  print " --> dataset timestamp $timestamp ";
  
  my $res = $datasetRs->create_from_scrape( $Scrape ) or die "create failed";
  
  $res eq '1' ? print "[exists, skipped]" : print "[populated]";

}


