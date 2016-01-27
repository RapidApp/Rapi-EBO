package Rapi::EBO::DB::ResultSet::Tick;
use Moo;
extends 'DBIx::Class::ResultSet';

use strict;
use warnings;

use Scalar::Util 'blessed';
use DateTime::Format::Flexible;

use RapidApp::Util ':all';

sub schema      { (shift)->result_source->schema          }
sub candidateRs { (shift)->schema->resultset('Candidate') }
sub contestRs   { (shift)->schema->resultset('Contest')   }


sub chart_rs {
  (shift)
    ->search_rs(undef,{
      join         => [qw/dataset candidate/],
      select       => [qw/me.pct dataset.ts candidate.name dataset.ts/],
      as           => [qw/pct ts candidate label/],
      order_by     => { -asc => 'dataset.ts' },
      result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    })
}


# Avg method:
sub chart_rs_by {
  my ($self, $by) = @_;
  
  $by ||= 'ts';
  
  $self
    ->chart_rs
    ->search_rs(undef,{
      select    => [{ round => [{ avg => 'me.pct'},2]}, "dataset.$by", 'candidate.name'],
      as        => [qw/pct ts candidate/],
      group_by  => ["dataset.$by", 'candidate.name']
    })
}


sub by_closings_rs {
  my ($self, $by) = @_;
  
  $by ||= 'hour';
  
  $self
    ->search_rs(undef,{ join => { dataset => 'closings' } })
    ->search_rs({ 'closings.by' => $by })
    ->search_rs(undef,{ '+select' => ['closings.label'], '+as' => ['label'] })
}

sub get_chart_data {
  my $self = shift;
  
  return {
    cfg => {
      value_column  => 'pct', point_column => 'label', group_column => 'candidate',
      group_rgb_map => $self->candidateRs->get_rgb_map
    },
    
    rows => [ $self->all ]
  }
}



sub _slot_ranges {{
  minute  => { minutes => 90   },
  hour    => { hours   => 20   },
  halfday => { days    => 10   },
  day     => { days    => 20   },
  week    => { days    => 10*7 },
  month   => { months  => 10   },
  year    => { years   => 10   }
}}

sub for_max_ts_by {
  my ($self, $dt, $by) = @_;
  
  $dt = blessed($dt) && blessed($dt) eq 'DateTime' ? $dt : DateTime::Format::Flexible->parse_datetime($dt);
  $by ||= 'hour';
  
  my $range = $self->_slot_ranges->{$by} || { hours => 2 };
  
  my $min_dt = $dt->clone->subtract( %$range );

  my $low  = join(' ',$min_dt->ymd('-'),$min_dt->hms(':'));
  my $high = join(' ',$dt->ymd('-'),$dt->hms(':'));
  
  $self
    ->search_rs(undef,{ join => 'dataset' })
    ->search_rs({ '-and' => [
      { 'dataset.ts' => { '>' => $low   }},
      { 'dataset.ts' => { '<' => $high }}
    ]})
    
}

sub for_min_ts_by {
  my ($self, $dt, $by, $maxnow) = @_;
  
  $dt = blessed($dt) && blessed($dt) eq 'DateTime' ? $dt : DateTime::Format::Flexible->parse_datetime($dt);
  $by ||= 'hour';
  
  my $range = $self->_slot_ranges->{$by} || { hours => 2 };
  my $max_dt = $dt->clone->add( %$range );
  
  if($maxnow) {
    my $now_dt = DateTime->now( time_zone => 'local' );
    return $self->for_max_ts_by($now_dt, $by) if ($max_dt > $now_dt);
  }
  
  my $thresh = join(' ',$max_dt->ymd('-'),$max_dt->hms(':'));
  
  my $Next = $self
    ->search_rs(undef,{ join => 'dataset' })
    ->search_rs({ 'dataset.ts' => { '>' => $thresh } })
    ->search_rs(undef,{ order_by => { -asc => 'dataset.ts' }, rows => 1 })
    ->first;
    
  if($Next) {
    $max_dt = (blessed $Next) 
      ? $Next->dataset->ts 
      : DateTime::Format::Flexible->parse_datetime($Next->{ts});
      
    $max_dt = $max_dt->clone->add( seconds => 1 );
  }
  
  return $self->for_max_ts_by($max_dt, $by)
}








1.