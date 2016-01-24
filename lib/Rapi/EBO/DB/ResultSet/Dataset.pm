package Rapi::EBO::DB::ResultSet::Dataset;
use Moo;
extends 'DBIx::Class::ResultSet';

use strict;
use warnings;

use Scalar::Util 'blessed';

sub schema      { (shift)->result_source->schema          }
sub candidateRs { (shift)->schema->resultset('Candidate') }
sub contestRs   { (shift)->schema->resultset('Contest')   }

sub create_from_scrape {
  my ($self, $Scrape) = @_;
  
  die "Bad arguments - expected Rapi::EBO::Scrape object"
    unless ($Scrape && (blessed $Scrape) eq 'Rapi::EBO::Scrape');
  
  # Already exists/loaded:
  return 1 if ($self->search_rs({ 'me.ts' => $Scrape->timestamp })->count);
  
  my $Data = $Scrape->Data;
  
  my @ticks = ();
  
  for my $name (keys %{ $Data->{Democratic} }) {
    push @ticks, { 
      contest   => $self->contestRs->find_or_create({ name => 'Democratic' }),
      candidate => $self->candidateRs->find_or_create({ name => $name }),
      pct => $Data->{Democratic}{$name}{pct}
    }
  }
  
  for my $name (keys %{ $Data->{Republican} }) {
    push @ticks, { 
      contest   => $self->contestRs->find_or_create({ name => 'Republican' }),
      candidate => $self->candidateRs->find_or_create({ name => $name }),
      pct => $Data->{Republican}{$name}{pct}
    }
  }
  
  for my $name (keys %{ $Data->{Presidency} }) {
    push @ticks, { 
      contest   => $self->contestRs->find_or_create({ name => 'Presidency' }),
      candidate => $self->candidateRs->find_or_create({ name => $name }),
      pct => $Data->{Presidency}{$name}{pct}
    }
  }
  
  
  $self->create({ ts => $Scrape->timestamp, ticks => \@ticks })
}


1.