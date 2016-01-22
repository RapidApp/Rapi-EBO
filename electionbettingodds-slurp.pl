#!/usr/bin/perl

use strict;

use LWP::Simple;
use Path::Class qw(file dir);
use DateTime;

my $VERSION = '0.01';

die "Must supply output dir as argument\n" unless ($ARGV[0]);

my $dir = dir( $ARGV[0] )->resolve;

my $dt = DateTime->now( time_zone => 'local' );
my $ts = join('_',$dt->ymd('-'), sprintf('%02d',$dt->hour) . sprintf('%02d',$dt->minute));


my $i = 0;
my $File = $dir->file( &ts_to_filename($ts) );

while( -e $File ) {
  $File = $dir->file( &ts_to_filename(join('.',$ts,++$i)) );
}


my $url = 'http://electionbettingodds.com';

my $content = get($url);
die "GET $url failed\n" unless (defined $content);

my $len = length $content;


$File->spew( $content );

print "$File written ($len bytes)\n";




############################################
exit;
############################################


sub ts_to_filename($) {
  my $ts = shift;
  return join('.','electionbettingodds.com',$ts,'html')
}

