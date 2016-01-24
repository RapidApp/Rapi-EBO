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
  
  if($datasetRs->search_rs({ 'me.ts' => $timestamp })->count) {
    print "[exists, skipping]";
    next;
  }
  
  my $Data = $Scrape->Data;
  
  my @ticks = ();
  
  for my $name (keys %{ $Data->{Democratic} }) {
    push @ticks, { 
      contest_id => 1,
      candidate => $candidateRs->find_or_create({ name => $name }),
      pct => $Data->{Democratic}{$name}{pct}
    }
  }
  
  for my $name (keys %{ $Data->{Republican} }) {
    push @ticks, { 
      contest_id => 2,
      candidate => $candidateRs->find_or_create({ name => $name }),
      pct => $Data->{Republican}{$name}{pct}
    }
  }
  
  for my $name (keys %{ $Data->{Presidency} }) {
    push @ticks, { 
      contest_id => 3,
      candidate => $candidateRs->find_or_create({ name => $name }),
      pct => $Data->{Presidency}{$name}{pct}
    }
  }
  
  
  $datasetRs->create({ ts => $timestamp, ticks => \@ticks }) or die "create failed";
  
  print "[populated]";
  

}


