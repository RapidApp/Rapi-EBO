package Rapi::EBO::Scrape;

use strict;
use warnings;

# ABSTRACT: scraper for electionbettingodds.com homepage 

use Moo;
use Types::Standard qw(:all);

use Web::Scraper;
use DateTime::Format::Flexible;

has 'html', is => 'ro', isa => Str, required => 1;

sub BUILD {
  my $self = shift;
  $self->timestamp; # scrape/init all right away
}


has 'web_scraper', is => 'ro', default => sub {
  scraper {
    process 'body > p:first-child > i'    => 'lastUpd'  => 'TEXT';
    process 'tr > td:nth-child(1) > img'  => 'dImg[]' => '@src';
    process 'tr > td:nth-child(2) > p'    => 'dPct[]' => 'TEXT';
    process 'tr > td:nth-child(3) > img'  => 'rImg[]' => '@src';
    process 'tr > td:nth-child(4) > p'    => 'rPct[]' => 'TEXT';
    process 'tr > td:nth-child(5) > img'  => 'gImg[]' => '@src';
    process 'tr > td:nth-child(6) > p'    => 'gPct[]' => 'TEXT';
  };
}, isa => InstanceOf['Web::Scraper'], init_arg => undef;


has 'scrape_result', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  $self->web_scraper->scrape( $self->html );
}, isa => HashRef, init_arg => undef;


has 'timestamp_dt', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  $self->_parse_timestamp_dt( $self->scrape_result->{lastUpd} )
}, isa => InstanceOf['DateTime'], init_arg => undef;

has 'timestamp', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  my $dt = $self->timestamp_dt;
  return $dt->ymd('-') . ' ' . $dt->hms(':');
}, isa => Str, init_arg => undef;

has 'Data', is => 'ro', lazy => 1, default => sub {
  my $self = shift;
  
  my $res = $self->scrape_result;
  
  my $Data = {
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
  
  return $Data

}, isa => HashRef, init_arg => undef;



sub _parse_timestamp_dt {
  my $self = shift;
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
  
  return $dt
}

1;