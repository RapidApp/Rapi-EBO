package Rapi::EBO::Controller::Chart;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use strict;
use warnings;

use RapidApp::Util ':all';


sub index :Path :Args(1) {
    my ( $self, $c, $contest ) = @_;
    
    my $Contest = $c->model('DB::Contest')->search_rs({ -or => [
      { 'me.id'   => $contest },
      { 'me.name' => $contest }
    ]})->first or die "Contest '$contest' not found";
    
    my $chart_data = $Contest
      ->ticks
      ->search_rs({ 'dataset.ts' => { '<' => '2016-01-16 00:00:00' }},{ join => 'dataset' } )
      ->get_chart_data;
    
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
