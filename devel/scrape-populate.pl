#!/usr/bin/perl

use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Rapi::EBO::Scrape;

use Rapi::EBO::Model::DB;
my $db = Rapi::EBO::Model::DB->_one_off_connect;
my $datasetRs   = $db->resultset('Dataset');
my $candidateRs = $db->resultset('Candidate');

my $Last = $datasetRs->by_most_recent->first;
my $last_ts = $Last ? $Last->get_column('ts') : undef;

use Path::Class qw(file dir);
use RapidApp::Util ':all';

my $Dir = dir( $ARGV[0] )->resolve;

for my $File ( $Dir->children ) {
  next if($File->is_dir);

  print "\n[$File]\n";
  
  ## -- new: skip according to timestamp in the filename for speed:
  if($last_ts) {
    my $bn = $File->basename;
    my @parts = split(/\./,$bn);
    if(scalar(@parts) == 4) {
      my $fts = $parts[2];
      my ($date,$time) = split(/\_/,$fts);
      my ($h,$m) = (substr($time,0,2),substr($time,2,2));
      
      my $f_timestamp = $date . ' ' . join(':',$h,$m,'00');
      
      if($f_timestamp && $last_ts gt $f_timestamp) {
        print " skipping -- before $last_ts";
        next;
      }
    }
  }
  ## --

  my $content = $File->slurp;
  
  my $Scrape = Rapi::EBO::Scrape->new({ html => $content });
  
  my $timestamp = $Scrape->timestamp;
  
  print " --> dataset timestamp $timestamp ";
  
  my $res = $datasetRs->create_from_scrape( $Scrape ) or die "create failed";
  if($res eq '1') {
    print "[exists, skipped]";
    next;
  }
  
  #scream({ $res->get_columns });
  
  print "[populated]";

}


