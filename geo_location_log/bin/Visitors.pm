#!usr/bin/perl
package Visitors;

use strict;
use warnings;
use Data::Dumper;
use lib "../";
use 5.008;
use GeoIP2::Database::Reader;

my $path = "../GeoLite2-City.mmdb";

#my $ip_address = '131.253.24.100';
my $reader = GeoIP2::Database::Reader->new( file => $path );

#print 'File name:' . $reader->file() . "\n";
#print 'Record: ' . Dumper($reader->record_for_address($ip_address)) . "\n";

our %cities = ();

sub new {
    my ($class, %args) = @_;
    return bless { %args}, $class;
}

sub get_city {
    my $self = shift;
    my $ip   = shift;
    my $city = $reader->city( ip => $ip )->_raw_city()->{names}->{en};
    if ( !defined $city ) {
        my $city = 'Unknown';
        return $city;
    }
    else {
        add_cities_hash($self, $city);
        return $city;
    
    }
}

sub get_country {
    my $self    = shift;
    my $ip      = shift;
    my $country = $reader->city( ip => $ip )->country()->{names}->{en};
    if ( !defined $country ) {
        my $country = 'Unknown';
        return $country;
    }
    else {
        return $country;
    }
}

sub add_cities_hash {
    my ($self) = shift;
    my $city = shift;

    if ( exists $self->{'cities'} ) {
        print "\n incrementar\n";
        $cities{$city} = $cities{$city} ++;
        print 'Dumper cities: ' . Dumper(%cities) . "\n";
    }
    else {
        print "\n Criar\n ";
        $cities{$city} = 1;
    }
    #return {'lisbon' -> 1 , 'braga' -> 12}
}


sub add_countries_hash{

}
#print 'City: ' . get_city($ip_address) . '--- Country: ' . get_country($ip_address) . "\n";

1;