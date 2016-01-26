use utf8;
package Rapi::EBO::DB::Result::Slot;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("slot");
__PACKAGE__->add_columns(
  "name",
  { data_type => "varchar", is_nullable => 0, size => 8 },
);
__PACKAGE__->set_primary_key("name");
__PACKAGE__->has_many(
  "closings",
  "Rapi::EBO::DB::Result::Closing",
  { "foreign.by" => "self.name" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-26 13:45:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TumSfZpl3xCbS8Nr8rtWYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
