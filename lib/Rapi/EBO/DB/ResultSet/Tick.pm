package Rapi::EBO::DB::ResultSet::Tick;
use Moo;
extends 'DBIx::Class::ResultSet';

use strict;
use warnings;

use Scalar::Util 'blessed';
use DateTime::Format::Flexible;

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


sub for_max_ts_by {
  my ($self, $dt, $by) = @_;
  
  $dt = $dt && blessed($dt) eq 'DateTime' ? $dt : DateTime::Format::Flexible->parse_datetime($dt);
  $by ||= 'hour';
  
  my $min_dt = 
    $by eq 'hour'     ? $dt->clone->subtract( hours  => 20   ) :
    $by eq 'halfday'  ? $dt->clone->subtract( days   => 10   ) :
    $by eq 'day'      ? $dt->clone->subtract( days   => 20   ) :
    $by eq 'week'     ? $dt->clone->subtract( days   => 10*7 ) :
    $by eq 'month'    ? $dt->clone->subtract( months => 10   ) :
    $by eq 'year'     ? $dt->clone->subtract( years  => 10   ) :
                        $dt->clone->subtract( hours  => 2    );
    
  my $low  = join(' ',$min_dt->ymd('-'),$min_dt->hms(':'));
  my $high = join(' ',$dt->ymd('-'),$dt->hms(':'));
  
  $self
    ->search_rs(undef,{ join => 'dataset' })
    ->search_rs({ '-and' => [
      { 'dataset.ts' => { '>' => $low   }},
      { 'dataset.ts' => { '<' => $high }}
    ]})
    
}








1.