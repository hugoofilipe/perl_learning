#!usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use feature qw(say);

use lib '/servers/libs/novis';
use Sonaecom::Logger;

my $file_name = $ARGV[0] or die "Need to get CSV file on the command line\n";

welcome();
handle_data();
terminate();

#print_content();

sub open_file {
    open( my $data, '<', $file_name )
        or die "Could not open $file_name.\nError_log:$!\n";
    return $data;
}

sub handle_data {
    my $data = open_file();
    while ( my $line = <$data> ) {
        chomp $line;
        my @fields = split ",", $line;
        print_content( @fields );
    }
}

sub welcome {
    if ( not defined $file_name ) {
        die "Need name of file \n";
    }
    say( '********* welcome ******* ' );
    return;
}

sub print_content {
    foreach ( @_ ) {
        print( $_ . ' - ' );
    }
    print "\n";
}

sub terminate {
    die say "Hasta La Vista";
}