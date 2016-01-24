#!/usr/bin/perl

use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Rapi::EBO;
my $datasetRs   = Rapi::EBO->model('DB::Dataset');
my $candidateRs = Rapi::EBO->model('DB::Candidate');

use Path::Class qw(file dir);
use Web::Scraper;
use DateTime::Format::Flexible;

use RapidApp::Util ':all';

my $Dir = dir( $ARGV[0] )->resolve;

for my $File ( $Dir->children ) {

  print "\n[$File]\n";

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

  my $timestamp = &parse_timestamp($res->{lastUpd});
  
  print " --> dataset timestamp $timestamp ";
  
  if($datasetRs->search_rs({ 'me.ts' => $timestamp })->count) {
    print "[exists, skipping]";
    next;
  }


  my $Data = {
    _timestamp => $timestamp,
    Democratic => {},
    Republican => {},
    Presidency => {}
  };


  for my $img (@{$res->{dImg}}) {
    my @parts = split(/\//,$img);
    my $fn = pop @parts;
    $fn =~ /^(\w+)\..+$/;
    my $name = $1;
    
    my $pct = (shift @{$res->{dPct}});
    $pct =~ s/\%//;
    $Data->{Democratic}{$name} = { img => $img, pct => $pct };
  }

  for my $img (@{$res->{rImg}}) {
    my @parts = split(/\//,$img);
    my $fn = pop @parts;
    $fn =~ /^(\w+)\..+$/;
    my $name = $1;
    
    my $pct = (shift @{$res->{rPct}});
    $pct =~ s/\%//;
    $Data->{Republican}{$name} = { img => $img, pct => $pct };
  }

  for my $img (@{$res->{gImg}}) {
    my @parts = split(/\//,$img);
    my $fn = pop @parts;
    $fn =~ /^(\w+)\..+$/;
    my $name = $1;
    
    my $pct = (shift @{$res->{gPct}});
    $pct =~ s/\%//;
    $Data->{Presidency}{$name} = { img => $img, pct => $pct };
  }
  
  
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
  
  
  #scream(\@ticks);
  
  
  #scream( $Data );
  


}







sub parse_timestamp {
  my $upd = shift;

  my $ts = (split(/Last updated\:\s+/, $upd ,2))[1];

  my ($time,$date) = split(/ on /,$ts,2);
  my $tz;
  ($time,$tz) = split(/\s+/,$time,2);
  my $pm = $time =~ /PM/i ? 1 : 0;
  $time =~ s/.{2}$//;
  my ($h,$m) = split(/\:/,$time,2);
  $h = $h + 12 if ($pm && $h < 12);

  my $dt = DateTime::Format::Flexible->parse_datetime($date);
  $dt->set_hour($h);
  $dt->set_minute($m);
  
  return $dt->ymd('-') . ' ' . $dt->hms(':');
}
