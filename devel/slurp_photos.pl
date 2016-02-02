#!/usr/bin/perl

use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use LWP::Simple;
use IPC::Cmd qw[can_run run_forked];
use Path::Class qw/file dir/;

use Rapi::EBO;
my $db = Rapi::EBO->model('DB')->schema;
my $CAS = Rapi::EBO->controller('SimpleCAS');

my %flags = map {$_=>1} @ARGV;

die 'morgify command not found, cannot shrink' if ($flags{'--shrink'} && !can_run('morgify'));

print "\n\nScanning for photo changes...\n\n";

for my $Candidate ($db->resultset('Candidate')->all) {
  my $fn = $Candidate->name . '.jpg';

  my $url = 'http://electionbettingodds.com/' . $fn;  

  print "Fetching $url ... ";
  
  my $content = get($url);
  die "GET $url failed\n" unless (defined $content);
  
  print "[success, " . (length $content) . ' bytes] ';
  
  if($flags{'--shrink'}) {
    my $tmp = file('_tmp-img-' . time . '-' . $fn);
    die "$tmp already exists? giving up" if (-e $tmp);
    $tmp->spew( $content );
    
    my @cmd = ('morgify','-resize','60x60',$tmp);
    
    print "\n   " . join(' ',@cmd);
    
    my $result = run_forked(\@cmd);
    my $exit = $result->{exit_code};
    
    print " [exit: $exit]\n";
    die "\n" . $result->{err_msg} if ($exit);
    
    $content = $tmp->slurp;
    unlink $tmp;
  
  }
  
  
  
  
  my $checksum = $CAS->Store->add_content( $content ) or die " err adding";
  
  my $val = join('/',$checksum,$fn);
  if(! $flags{'--force'} && $Candidate->photo_cas && $Candidate->photo_cas eq $val) {
    print "- no changes\n";
    next;
  }
  else {
    $Candidate->update({ photo_cas => $val }) or die " db update failed";
    print "- updated ($val)\n";
  }


};

