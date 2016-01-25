use utf8;
package Rapi::EBO::DB::Result::Dataset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("dataset");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "ts",
  { data_type => "datetime", is_nullable => 0 },
  "date",
  { data_type => "date", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("ts_unique", ["ts"]);
__PACKAGE__->has_many(
  "ticks",
  "Rapi::EBO::DB::Result::Tick",
  { "foreign.dataset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-25 15:16:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pLJp7i4YBIEN5mAQJY8UmA


sub insert {
  my ($self, $columns) = @_;
  $self->set_inflated_columns($columns) if ($columns);
  
  $self->_set_aggregate_columns;
  
  $self->next::method
}

sub update {
  my ($self, $columns) = @_;
  $self->set_inflated_columns($columns) if ($columns);
  
  $self->_set_aggregate_columns;
  
  $self->next::method
}



sub _set_aggregate_columns {
  my $self = shift;
  
  my $ts = $self->get_column('ts');
  
  $self->set_column( date => (split(/\s+/,$ts))[0] );

}



# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
