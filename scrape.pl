#!/usr/bin/perl

use strict;

use Path::Class qw(file dir);
use Web::Scraper;

use RapidApp::Util ':all';


my $File = file( $ARGV[0] )->resolve;
my $content = $File->slurp;

my $scraper = scraper {
  process 'body > p:first-child > i'    => 'lastUpd'  => 'TEXT';
  process 'tr > td:nth-child(1) > img'  => 'dImg[]' => '@src';
  process 'tr > td:nth-child(2) > p'    => 'dPct[]' => 'TEXT';
  process 'tr > td:nth-child(3) > img'  => 'rImg[]' => '@src';
  process 'tr > td:nth-child(4) > p'    => 'rPct[]' => 'TEXT';
  process 'tr > td:nth-child(5) > img'  => 'gImg[]' => '@src';
  process 'tr > td:nth-child(6) > p'    => 'gPct[]' => 'TEXT';
};

my $res = $scraper->scrape( $content );

my $ts = (split(/Last updated\:\s+/, $res->{lastUpd},2))[1];


my $Data = {
  _ts        => $ts,
  Democratic => {},
  Republican => {},
  Presidency => {}
};


for my $img (@{$res->{dImg}}) {
  $img =~ /^\/(\w+)\..+$/;
  my $name = $1;
  
  $Data->{Democratic}{$name} = {
    img => $img,
    pct => (shift @{$res->{dPct}})
  };
}

for my $img (@{$res->{rImg}}) {
  $img =~ /^\/(\w+)\..+$/;
  my $name = $1;
  
  $Data->{Republican}{$name} = {
    img => $img,
    pct => (shift @{$res->{rPct}})
  };
}

for my $img (@{$res->{gImg}}) {
  $img =~ /^\/(\w+)\..+$/;
  my $name = $1;
  
  $Data->{Presidency}{$name} = {
    img => $img,
    pct => (shift @{$res->{gPct}})
  };
}



scream( $Data );
