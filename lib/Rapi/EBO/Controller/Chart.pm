package Rapi::EBO::Controller::Chart;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use strict;
use warnings;

use RapidApp::Util ':all';
use DateTime;
use DateTime::Format::Flexible;
use Try::Tiny;


sub index :Path {
    my ( $self, $c, $contest, $by ) = @_;
    
    $contest ||= 3;
    $by ||= 'halfday';
    
    my $Contest = $c->model('DB::Contest')->search_rs({ -or => [
      { 'me.id'   => $contest },
      { 'me.name' => $contest }
    ]})->first or die "Contest '$contest' not found";
    
    my $dt = DateTime->now( time_zone => 'local' );
    
    if(my $before = $c->req->params->{before}) {
     $dt = DateTime::Format::Flexible->parse_datetime($before);
    
    }
    
    my $Rs = $Contest
      ->ticks
      #->chart_rs_by('halfday')
      ->chart_rs
      ->by_closings_rs($by);

    my $chart_data = $Rs
      ->for_max_ts_by($dt,$by)
      ->get_chart_data;
    
    my @rows = @{$chart_data->{rows}};
    my $low_ts  = $rows[0]->{ts};
    my $high_ts = $rows[$#rows]->{ts};
    
    my $vars = {
      chartcfg_json  => encode_json_utf8($chart_data->{cfg}),
      chartrows_json => encode_json_utf8($chart_data->{rows}),
      contest => $Contest->name,
      by   => $by,
      low  => $low_ts,
      high => $high_ts,
    };
    
    if($low_ts && $Rs->for_max_ts_by($low_ts,$by)->count > 0) {
      $vars->{prev} = '?before=' . $low_ts;
    }
    
    my $TC = $c->template_controller;
    my $body = $TC->template_render('chart.tt',$vars);

    $c->response->content_type('text/html; charset=utf-8');
    $c->response->body( $body );
}






__PACKAGE__->meta->make_immutable;

1;
