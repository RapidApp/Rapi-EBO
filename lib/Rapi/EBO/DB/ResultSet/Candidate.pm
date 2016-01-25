package Rapi::EBO::DB::ResultSet::Candidate;
use Moo;
extends 'DBIx::Class::ResultSet';

use strict;
use warnings;

use Scalar::Util 'blessed';


sub get_rgb_map {
  my $self = shift;
  
  my @rows = $self->search_rs(undef,{
    select => [qw/me.name color.red color.green color.blue/],
    as     => [qw/name r g b/],
    join   => 'color',
    result_class => 'DBIx::Class::ResultClass::HashRefInflator'
  })->all;
  
  return { map { $_->{name} => [$_->{r},$_->{g},$_->{b}] } @rows }
}




1.