package Rapi::EBO::DB::ResultSet::Color;
use Moo;
extends 'DBIx::Class::ResultSet';

use strict;
use warnings;

sub random_order {
  (shift)->search_rs(undef,{ order_by => \'RANDOM()' })
}


1.