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
      result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    })
}

sub get_chart_data {
  my $self = shift;
  
  return {
    cfg => {
      value_column  => 'pct', point_column => 'ts', group_column => 'candidate',
      group_rgb_map => $self->candidateRs->get_rgb_map
    },
    
    rows => [ $self->chart_rs->all ]
  }
}




1.