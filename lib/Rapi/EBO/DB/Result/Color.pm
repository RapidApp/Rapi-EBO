use utf8;
package Rapi::EBO::DB::Result::Color;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("color");
__PACKAGE__->add_columns(
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "hex",
  { data_type => "char", is_nullable => 0, size => 7 },
  "red",
  { data_type => "int", is_nullable => 0, size => 3 },
  "green",
  { data_type => "int", is_nullable => 0, size => 3 },
  "blue",
  { data_type => "int", is_nullable => 0, size => 3 },
);
__PACKAGE__->set_primary_key("name");
__PACKAGE__->has_many(
  "candidates",
  "Rapi::EBO::DB::Result::Candidate",
  { "foreign.color" => "self.name" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-24 17:04:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0spQPXXLtZNIvLW0Yq4Wdg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
