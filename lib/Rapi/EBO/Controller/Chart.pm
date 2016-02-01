package Rapi::EBO::Controller::Chart;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

__PACKAGE__->config( namespace => '' );

use strict;
use warnings;

use RapidApp::Util ':all';
use DateTime;

use DateTime::Format::Flexible;
sub parse_datetime { DateTime::Format::Flexible->parse_datetime(@_) }

use Try::Tiny;


sub index :Path {
    my ( $self, $c, $contest, $by ) = @_;
    
    # Back-compat support /chart/ paths -- before we moved this controller to /
    if($contest && $contest eq 'chart') {
      $contest = $_[3];
      $by = $_[4];
    }
    
    $contest ||= 3;
    $by ||= 'halfday';
    
    my $Contest = $c->model('DB::Contest')->search_rs({ -or => [
      { 'me.id'   => $contest },
      { 'me.name' => $contest }
    ]})->first or die "Contest '$contest' not found";
    
    my $dt;
    
    if(my $before = $c->req->params->{before}) {
      $dt = try{parse_datetime($before)} || DateTime->now( time_zone => 'local' );
    }
    else {
      my $Last = $c->model('DB::Dataset')->by_most_recent->first;
      $dt = $Last 
        ? $Last->ts->clone->add( minutes => 1 ) 
        : DateTime->now( time_zone => 'local' );
    }
    my $after_dt = $c->req->params->{after} ? try{parse_datetime($c->req->params->{after})} : undef;

    my $Rs = $Contest
      ->ticks
      #->chart_rs_by('halfday')
      ->chart_rs
      ->by_closings_rs($by);

    my $rangeRs = $after_dt 
      ? $Rs->for_min_ts_by($after_dt,$by,1)
      : $Rs->for_max_ts_by($dt,$by);
      
    my $chart_data = $rangeRs->get_chart_data;
    
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
      low_human => &ts_human($low_ts),
      high_human => &ts_human($high_ts),
      cur_path => join('/','','chart',$contest,$by)
    };
    
    if($low_ts && $Rs->for_max_ts_by($low_ts,$by)->count > 0) {
      $vars->{prev} = '?before=' . $low_ts;
    }
    if($high_ts && $Rs->for_min_ts_by($high_ts,$by)->count > 0) {
      $vars->{next} = '?after=' . $high_ts;
    }
    
    my $slot_links = {
      minute  => join('/','','chart',$contest,'minute'),
      hour    => join('/','','chart',$contest,'hour'),
      halfday => join('/','','chart',$contest,'halfday'),
      day     => join('/','','chart',$contest,'day'),
    };
    
    delete $slot_links->{$by} if ($slot_links->{$by});
    $vars->{slot_links} = $slot_links;
    
    my $contest_links = {
      Democratic => join('/','','chart',1,$by),
      Republican => join('/','','chart',2,$by),
      Presidency => join('/','','chart',3,$by),
    };
    delete $contest_links->{$Contest->name} if ($contest_links->{$Contest->name});
    $vars->{contest_links} = $contest_links;
    
    
    my $TC = $c->template_controller;
    my $body = $TC->template_render('chart.tt',$vars);

    $c->response->content_type('text/html; charset=utf-8');
    $c->response->body( $body );
}


sub ts_human {
  my $dt = shift or return '';
  $dt = parse_datetime($dt) unless (ref $dt);
  join('',$dt->ymd('-'),', ',$dt->hour_12,':',sprintf("%02d",$dt->minute),lc($dt->am_or_pm))
}




__PACKAGE__->meta->make_immutable;

1;
