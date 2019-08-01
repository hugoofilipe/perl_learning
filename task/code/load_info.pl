#!/usr/bin/perl

use strict;

use Carp;
use FindBin;
use lib ( '/servers/libs/novis', "$FindBin::Bin/lib" );
use Data::Dumper;

#use Sonaecom::Logger;
#my $l = Sonaecom::Logger::get_logger();

use DBD::SQLite;

require "common.pl";

$ENV{'DEBUG'} ||= 0;

my $data_dir = "$FindBin::Bin/data";
my $file_db  = $data_dir . '/t2_1.sqlite';

print STDERR "data_dir: $data_dir\n";
print STDERR "file_db: $file_db\n";

my $dbh = connect_db( $file_db );

my $do_room = get_dataobject( $data_dir . '/rooms.csv', 'room_id' );
print 'Total rooms: ' . $do_room->total_records() . "\n";

my $do_delegates = get_dataobject( $data_dir . '/delegates.csv', 'name' );
print 'Total delegates: ' . $do_delegates->total_records() . "\n";

my $do_talks = get_dataobject( $data_dir . '/presentations.csv', 'talk_id' );
print 'Total talks: ' . $do_talks->total_records() . "\n";

#while ( my $data = $do_room->next_record ) {
#    treat_one( $data );
#}
#print sprintf( "Total treated: %s in %s secs\n", $user_obj->total_treated, $user_obj->time_spent );

exit;

sub treat_one {
    my $data = shift;

    # do stuff here

}

