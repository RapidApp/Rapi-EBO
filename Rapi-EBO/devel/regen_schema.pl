# ----------  perl
# This file intentionally left w/o execute permission. Intended to be called
# manually via 'perl' command to make sure it is the same interpreter/env as
# the one used to run the app, which may not be the system perl.
#
# From the app root:
#
#    perl devel/regen_schema.pl
#
# ----------

use strict;
use warnings;

use DBIx::Class::Schema::Loader;
use Module::Runtime;
use IPC::Cmd qw[can_run run_forked];
use Path::Class qw(file dir);

my $Go = $ARGV[0] && $ARGV[0] eq '--go';

use FindBin;
use lib "$FindBin::Bin/../lib";

my $app_class   = 'Rapi::EBO';
my $model_class = 'Rapi::EBO::Model::DB';

my $approot = "$FindBin::Bin/..";
my $applib = "$approot/lib";

# make an $INC{ $key } style string from the class name
(my $pm = "$app_class.pm") =~ s{::}{/}g;
my $appfile = file($applib,$pm)->absolute->resolve;

# This is purely for Catalyst::Utils::home() which will be invoked when 
# we require the model class in the next statement so it can find the
# home directory w/o having to actually use/load the app class:
$INC{ $pm } = "$appfile";

Module::Runtime::require_module($model_class);

my ($schema_class,$dsn,$user,$pass) = (
  $model_class->config->{schema_class}, 
  $model_class->config->{connect_info}{dsn},
  $model_class->config->{connect_info}{user}, 
  $model_class->config->{connect_info}{password}
);



my @connect = ($dsn,$user,$pass);
print "\nDumping schema \"$schema_class\" to \"" . file($applib)->resolve->relative . "\"\n";
print "[ " . join(' ',map { $_||"''" } @connect) . " ]\n\n";

DBIx::Class::Schema::Loader::make_schema_at(
  $schema_class, 
  {
    debug => 1,
    dump_directory => $applib,
    use_moose	=> 1, generate_pod => 0,
    components => ["InflateColumn::DateTime"],
  },
  [ 
    @connect,
    { loader_class => 'RapidApp::Util::MetaKeys::Loader' }
  ]
);

print "\n";

