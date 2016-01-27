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
  "minute",
  { data_type => "char", is_nullable => 1, size => 16 },
  "hour",
  { data_type => "char", is_nullable => 1, size => 14 },
  "halfday",
  { data_type => "char", is_nullable => 1, size => 12 },
  "day",
  { data_type => "date", is_nullable => 1 },
  "week",
  { data_type => "char", is_nullable => 1, size => 8 },
  "month",
  { data_type => "char", is_nullable => 1, size => 9 },
  "quarter",
  { data_type => "char", is_nullable => 1, size => 7 },
  "year",
  { data_type => "int", is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("ts_unique", ["ts"]);
__PACKAGE__->has_many(
  "closings",
  "Rapi::EBO::DB::Result::Closing",
  { "foreign.dataset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "ticks",
  "Rapi::EBO::DB::Result::Tick",
  { "foreign.dataset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-27 14:20:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IocyAuUmScLE9f562LtxOA

use RapidApp::Util ':all';

sub schema    { (shift)->result_source->schema        }


sub insert {
  my ($self, $columns) = @_;
  $self->set_inflated_columns($columns) if ($columns);
  
  $self->_set_aggregate_columns;
  
  $self->next::method;
  
  $self->_update_closings
}

sub update {
  my ($self, $columns) = @_;
  $self->set_inflated_columns($columns) if ($columns);
  
  $self->_set_aggregate_columns;
  
  $self->next::method;
  
  $self->_update_closings
}



sub _set_aggregate_columns {
  my $self = shift;
  
  my $dt = $self->ts; # DateTime object
  
  $self->set_columns({
    minute   => join(':',$dt->ymd('-'),sprintf('%02d',$dt->hour).sprintf('%02d',$dt->minute)),
    hour     => join(':',$dt->ymd('-'),sprintf('%02d',$dt->hour)),
    halfday  => join('',$dt->ymd('-'),substr($dt->am_or_pm,0,1)),
    day      => $dt->ymd('-'),
    week     => join('w',$dt->year,sprintf('%02d',$dt->week_number)),
    month    => join('-',$dt->year,$dt->month_abbr),
    quarter  => join('Q',$dt->year,$dt->quarter),
    year     => $dt->year
  });

}

sub _update_closings {
  my $self = shift;
  
  my @slots = qw/minute hour halfday day week month quarter year/;
  
  my $Rs = $self->schema->resultset('Closing'); 
  
  for my $slot (@slots) {
    my $key = $self->get_column($slot);
    my $vals = { by => $slot, key => $key, dataset => $self };
    if(my $Existing = $Rs->search_rs({ key => $key })->first) {
      if($Existing->dataset->ts < $self->ts) {
        $Existing->update( $vals );
      }
    }
    else {
      $Rs->create( $vals );
    }
  }
  
  return $self
}



# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
