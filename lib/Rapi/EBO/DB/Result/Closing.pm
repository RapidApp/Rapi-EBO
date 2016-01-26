use utf8;
package Rapi::EBO::DB::Result::Closing;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("closing");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "by",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 8 },
  "key",
  { data_type => "varchar", is_nullable => 0, size => 14 },
  "dataset_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("key_unique", ["key"]);
__PACKAGE__->belongs_to(
  "by",
  "Rapi::EBO::DB::Result::Slot",
  { name => "by" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "RESTRICT" },
);
__PACKAGE__->belongs_to(
  "dataset",
  "Rapi::EBO::DB::Result::Dataset",
  { id => "dataset_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-26 13:45:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jsgYMoeSvWYOps4vsZhjpg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
