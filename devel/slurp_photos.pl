#!/usr/bin/perl

use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use LWP::Simple;

use Rapi::EBO;
my $db = Rapi::EBO->model('DB')->schema;
my $CAS = Rapi::EBO->controller('SimpleCAS');


print "\n\nScanning for photo changes...\n\n";

for my $Candidate ($db->resultset('Candidate')->all) {
  my $fn = $Candidate->name . '.jpg';

  my $url = 'http://electionbettingodds.com/' . $fn;  

  print "Fetching $url ... ";
  
  my $content = get($url);
  die "GET $url failed\n" unless (defined $content);
  
  print "[success, " . (length $content) . ' bytes] ';
  
  my $checksum = $CAS->Store->add_content( $content ) or die " err adding";
  
  my $val = join('/',$checksum,$fn);
  if($Candidate->photo_cas && $Candidate->photo_cas eq $val) {
    print "- no changes\n";
    next;
  }
  else {
    $Candidate->update({ photo_cas => $val }) or die " db update failed";
    print "- updated ($val)\n";
  }


};

