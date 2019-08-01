use strict;
use warnings;

use lib('/servers/libs/novis' );
use Sonaecom::Logger qw( get_logger );

#my $l = Sonaecom::Logger->get_logger();
my $l = get_logger();
# .. or ...
#my $l = get_logger('Gobal::Coverage');

#you have differente severities...
$l->info("bla");
$l->debug("bla");
$l->warn("blai2");
$l->fatal("bla4");
$l->error("bla4");
$l->ok("bla4");

#you can also log and time an action at the same time
my $t = $l->debug_timer("Invoking something");
print "zzzzZZZZzzzz   r0nk\n\n";
sleep(2);
$t->end();

#with any level of logging...
my $t2 = $l->warn_timer("Invoking something else");
sleep(2);
$t2->end();

#you also have all the neat log4perl stuff available
if ( $l->is_debug ) {
  $l->debug("hey... you'll read this");
  }

  $l->level('WARN');
  if ( $l->is_debug ) {
    $l->debug("... but not this");
    }
    $l->debug("... or this, even if you dont test the log level");
    
