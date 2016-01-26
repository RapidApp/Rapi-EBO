package Rapi::EBO::Controller::Chart;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use strict;
use warnings;

use RapidApp::Util ':all';
use DateTime;


sub index :Path {
    my ( $self, $c, $contest, $by ) = @_;
    
    $contest ||= 3;
    $by ||= 'halfday';
    
    my $Contest = $c->model('DB::Contest')->search_rs({ -or => [
      { 'me.id'   => $contest },
      { 'me.name' => $contest }
    ]})->first or die "Contest '$contest' not found";
    
    my $dt = DateTime->now( time_zone => 'local' );
    
    my $thresh_dt = 
      $by eq 'hour'     ? $dt->clone->subtract( hours  => 20 ) :
      $by eq 'halfday'  ? $dt->clone->subtract( days   => 10 ) :
      $by eq 'day'      ? $dt->clone->subtract( days   => 20 ) :
      $by eq 'week'     ? $dt->clone->subtract( days   => 10*7 ) :
      $by eq 'month'    ? $dt->clone->subtract( months => 10 ) :
      $by eq 'year'     ? $dt->clone->subtract( years  => 10 ) :
      $dt->clone->subtract( hours  => 2 );
    
    my $thresh = join(' ',$thresh_dt->ymd('-'),$thresh_dt->hms(':'));
    
    my $Rs = $Contest
      ->ticks
      ->search_rs({ 'dataset.ts' => { '>' => $thresh }},{ join => 'dataset' } )
      #->chart_rs_by('halfday')
      ->chart_rs
      ->by_closings_rs($by);

    my $chart_data = $Rs->get_chart_data;
    
    my $TC = $c->template_controller;
    
    my $body = $TC->template_render('chart.tt', {
      chartcfg_json  => encode_json_utf8($chart_data->{cfg}),
      chartrows_json => encode_json_utf8($chart_data->{rows})
    });

    $c->response->content_type('text/html; charset=utf-8');
    $c->response->body( $body );
}



__PACKAGE__->meta->make_immutable;

1;
