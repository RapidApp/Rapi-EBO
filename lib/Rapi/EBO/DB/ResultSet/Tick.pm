package Rapi::EBO::DB::ResultSet::Tick;
use Moo;
extends 'DBIx::Class::ResultSet';

use strict;
use warnings;

use Scalar::Util 'blessed';

sub schema      { (shift)->result_source->schema          }
sub candidateRs { (shift)->schema->resultset('Candidate') }
sub contestRs   { (shift)->schema->resultset('Contest')   }


sub chart_rs {
  (shift)
    ->search_rs(undef,{
      join         => [qw/dataset candidate/],
      select       => [qw/me.pct dataset.ts candidate.name/],
      as           => [qw/pct ts candidate/],
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
    ->search_rs(undef,{ '+select' => ['closings.label'], '+as' => ['ts'] })
}

sub get_chart_data {
  my $self = shift;
  
  return {
    cfg => {
      value_column  => 'pct', point_column => 'ts', group_column => 'candidate',
      group_rgb_map => $self->candidateRs->get_rgb_map
    },
    
    rows => [ $self->all ]
  }
}









1.