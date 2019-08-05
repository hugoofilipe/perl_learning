#!/usr/bin/perl

use strict;

use Carp;
use Try::Tiny;
use FindBin;
use lib ( '/servers/libs/novis', "$FindBin::Bin/lib" );
use Data::Dumper;

use Sonaecom::Logger;
my $l = Sonaecom::Logger::get_logger();

use DBD::SQLite;

require "common.pl";

#$ENV{'DEBUG'} ||= 0;
$ENV{'DEBUG'} = 1;

my $data_dir = "$FindBin::Bin/data";
my $file_db  = $data_dir . '/t2_1.sqlite';


print STDOUT "data_dir: $data_dir\n";
print STDOUT "file_db: $file_db\n";

my $dbh = connect_db( $file_db );

my $do_room = get_dataobject( $data_dir . '/rooms.csv', 'room_id' );
print 'Total rooms: ' . $do_room->total_records() . "\n";

my $do_delegates = get_dataobject( $data_dir . '/delegates.csv', 'name' );
print 'Total delegates: ' . $do_delegates->total_records() . "\n";

my $do_talks = get_dataobject( $data_dir . '/presentations.csv', 'talk_id' );
print 'Total talks: ' . $do_talks->total_records() . "\n";

try {
    while ( my $data = $do_room->next_record ) {
        insert_into_database( $data, $dbh , 'rooms');
    }
      while ( my $data = $do_delegates->next_record ) {
        insert_into_database( $data, $dbh , 'delegates');
    }
      while ( my $data = $do_talks->next_record ) {
        insert_into_database( $data, $dbh, 'presentations' );
    }
    $dbh->commit;
}
catch {
    $l->error("Something is wrong with reference data!!!");
    eval { $dbh->rollback };
};


#print sprintf( "Total treated: %s in %s secs\n", $user_obj->total_treated, $user_obj->time_spent );
