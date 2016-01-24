use utf8;
package Rapi::EBO::DB::Result::Candidate;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("candidate");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "photo_cas",
  { data_type => "text", default_value => \"null", is_nullable => 1 },
  "full_name",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "color",
  {
    data_type => "varchar",
    default_value => \"null",
    is_foreign_key => 1,
    is_nullable => 1,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("name_unique", ["name"]);
__PACKAGE__->belongs_to(
  "color",
  "Rapi::EBO::DB::Result::Color",
  { name => "color" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);
__PACKAGE__->has_many(
  "ticks",
  "Rapi::EBO::DB::Result::Tick",
  { "foreign.candidate_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-24 17:55:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ypeIBcibWt4G8ssNi5qT2Q

sub schema  { (shift)->result_source->schema      }
sub colorRs { (shift)->schema->resultset('Color') }

sub insert {
  my $self = shift;
  my $columns = shift;
  
  $self->set_inflated_columns($columns) if ($columns);
  
  # Pick a random color if none is specified
  $self->set_column( 
    color => $self->colorRs->random_order->first->name 
  ) unless ($self->color);
  
  $self->set_column( full_name => $self->name ) unless ($self->full_name);
  
  $self->next::method
}




# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
