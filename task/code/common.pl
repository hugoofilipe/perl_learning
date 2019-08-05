#!/usr/bin/perl

use strict;
use warnings;

use Sonaecom::DSManager::File::CSV;

use Carp;

sub connect_db {
    my $file_db = shift;

    my $init_db = 0;
    if ( !-f $file_db ) {
        $init_db = 1;
    }

    my $con_str = "dbi:SQLite:dbname=$file_db";
    my $dbh = DBI->connect( $con_str, q{}, q{}, { 'RaiseError' => 1 , 'AutoCommit'=>0} );

    if ( not $dbh ) {
        croak "unable to DBI connect: $!\n";
    }

    if ( $init_db ) {
        _init_db( $dbh );
        print STDERR "DB initialized\n";
    }

    print STDERR "Created dbh!\n";

    return $dbh;
}

sub _init_db {
    my $dbh = shift;

    my $query
        = q{ CREATE TABLE rooms( room_id INTEGER NOT NULL PRIMARY KEY, room_name text NOT NULL, capacity INTEGER NOT NULL, UNIQUE(room_id)) };

    if ( !$dbh->do( $query ) ) {
        croak "Unable to create 'rooms': $!";
    }
    print STDERR "Created rooms ...\n";

    $query
        = q{ CREATE TABLE delegates( delegate_id INTEGER NOT NULL PRIMARY KEY, name text NOT NULL, country text, UNIQUE(delegate_id)) };
    if ( !$dbh->do( $query ) ) {
        croak "Unable to create 'delegates': $!";
    }
    print STDERR "Created delegates ...\n";

    $query = <<'END_HERE';
CREATE TABLE presentations( talk_id INTEGER not NULL PRIMARY KEY,
                            delegate_name text NOT NULL,
                            room_id INTEGER NOT NULL,
                            title text NOT NULL,
                            date_time text NOT NULL,
                            duration_min INTEGER NOT NULL,
                            UNIQUE(talk_id))
 
END_HERE

    if ( !$dbh->do( $query ) ) {
        croak "Unable to create 'presentations': $!";
    }
    print STDERR "Created presentations ...\n";

    $dbh->commit;

    return;
}

sub insert_into_database {
    my ( $data, $dbh, $table ) = @_;
    print 'table:' . $table;
    my @columns = keys %$data;
    my @values = values %$data;
    my $fieldlist          = join ", ", @columns;
    my $field_placeholders = join ", ", map {'?'} @columns;
    my $insert_query       = qq{
        INSERT INTO $table ( $fieldlist )
         VALUES ( $field_placeholders )};
    my $sth = $dbh->prepare( $insert_query );
    $sth->execute(@values);
}

sub get_dataobject {
    my $filename         = shift;
    my $primary_key_name = shift;

    my $data_object = Sonaecom::DSManager::File::CSV->new(
        'debug'               => $ENV{'DEBUG'},
        'strip_empty'         => 1,
        'key_name'            => $primary_key_name,
        'col_names_from_file' => 1,                   #csv specific
    );
    $data_object->set_input_file( $filename );
    $data_object->prepare_records( 'key_name' => $primary_key_name );
    return $data_object;
}

1;
