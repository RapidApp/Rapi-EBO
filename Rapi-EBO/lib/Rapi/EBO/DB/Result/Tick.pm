use utf8;
package Rapi::EBO::DB::Result::Tick;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("tick");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "dataset_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "contest_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "candidate_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "pct",
  { data_type => "decimal", is_nullable => 0, size => [4, 2] },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "candidate",
  "Rapi::EBO::DB::Result::Candidate",
  { id => "candidate_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "RESTRICT" },
);
__PACKAGE__->belongs_to(
  "contest",
  "Rapi::EBO::DB::Result::Contest",
  { id => "contest_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "RESTRICT" },
);
__PACKAGE__->belongs_to(
  "dataset",
  "Rapi::EBO::DB::Result::Dataset",
  { id => "dataset_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-23 18:58:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VtbdJ9CvmHgq1CtuYUHLdw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
