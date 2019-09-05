#!usr/bin/perl
package Visitors;

use strict;
use warnings;
use Data::Dumper;
use lib "../";
use 5.008;
use List::UtilsBy qw(max_by);
use GeoIP2::Database::Reader;

#rever
use constant use_HTML => 1;

my $path = "../GeoLite2-City.mmdb";

#my $ip_address = '131.253.24.100';
my $reader = GeoIP2::Database::Reader->new( file => $path );

#print 'File name:' . $reader->file() . "\n";
#print 'Record: ' . Dumper($reader->record_for_address($ip_address)) . "\n";

my %cities ;
my %countries;
my %pages_by_country;

sub new {
    my ( $class, %args ) = @_;
    return bless {%args}, $class;
}

sub get_city {
    my $self = shift;
    my $ip   = shift;
    my $city = $reader->city( ip => $ip )->_raw_city()->{names}->{en};
    if ( !defined $city ) {
        my $city = 'Unknown';
        add_cities_hash( $self, $city );
        return;
    }
    add_cities_hash( $self, $city );
}

sub get_country {
    my $self    = shift;
    my $ip      = shift;
    my $path    = shift;
    my $country = $reader->city( ip => $ip )->country()->{names}->{en};
    if ( !defined $country ) {
        my $country = 'Unknown';
        add_countries_hash( $self, $country );
        return;
    }
    add_countries_hash( $self, $country, $path );
}

sub add_cities_hash {
    my $self = shift;
    my $city = shift;
    my $path = shift;
    if ( exists $cities{$city} ) {
        $cities{$city}++;
    }
    else {
        $cities{$city} = 1;
    }
}

sub add_countries_hash {
    my $self    = shift;
    my $country = shift;
    my $page    = shift;

    if ( exists $countries{$country} ) {
        $countries{$country}{num}++;
        if (defined $page){
            if ( exists $countries{$country}{$page} ) {
                $countries{$country}{$page}++;
            }
            else {
                $countries{$country}{$page} = 1;
            }
        }
    }
    else {
        $countries{$country}{num} = 1;
        if (defined $page){
                    $countries{$country}{$page} = 1;
        }
    }
}

#top 10 cities maximum, sorting by number of cities cases
sub cities_list {
    my $self  = shift;
    my $size  = keys %cities;
    my $limit = 9;
    if ( $limit > $size ) {
        $limit = $size - 1;
    }
    my @html = ();
    print "Top 10 cities:\n";
    foreach my $city (
        ( sort { $cities{$b} <=> $cities{$a} } keys( %cities ) )[ 0 .. $limit ]
        ) {
        print "$city ------- $cities{$city}\n";
        push @html, "<p>$city ------- $cities{$city}</p>";
    }
    if ( use_HTML ) {
        return ( "<h1>Top 10 cities:</h1>", @html );
    }
}

#top 10 countries maximum, sorting by number of countries cases
sub countries_list {
    my $self  = shift;
    my $size  = keys %countries;
    my $limit = 9;
    my @html  = ();

    if ( $limit > $size ) {
        $limit = $size - 1;
    }
    print "\nTop 10 countries:\n";
    foreach my $country (
        (   sort { $countries{$b}{num} <=> $countries{$a}{num} }
            keys( %countries )
        )[ 0 .. $limit ]
        ) {
        print "$country ------- $countries{$country}{num}";
        my $highest_page_view = find_page_more_visited( $self, $country );
        print "--- Page: $highest_page_view\n";

        push @html,
            "<p>$country ------- $countries{$country}{num} ----Page: $highest_page_view</p>";
    }
    if ( use_HTML ) {
        return ( "<h1>Top 10 contries:</h1>", @html );
    }
}

sub find_page_more_visited {
    my $self    = shift;
    my $country = shift;
    my $num = $countries{$country}{num};
    delete $countries{$country}{num};
    my $highest = max_by { $countries{$country}{$_} } keys %{$countries{$country} };
    #print "\nhighest: $highest\n";
    #print "value: $countries{$country}{ $highest }\n";
    $countries{$country}{num}=$num;
    return $highest;
}

1;
