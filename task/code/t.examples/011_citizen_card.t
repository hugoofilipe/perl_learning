#!

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);

use Test::More tests => 29;
use Data::Dumper;

require_ok( 'Novis::Verify' );

my $ret;

#####
#
#  DDDDDDDDCAAT
#
#  D - identification civil number [0..9]
#  C - identification civil check digit number [0..9]
#  A - Version [A..Z, 0..9]
#  T - check digit of document number [0..9]
#
#####

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

$ret = $vrf->verify_citizen_card_number();
is( $ret, undef, 'verify_citizen_card_number no params' );

$ret = $vrf->verify_citizen_card_number( 'ccnumber' => q{} );
is( $ret, 8004, 'verify_citizen_card_number empty param, no ob flag' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1 );
is( $ret, 8001, 'verify_citizen_card_number missing param' );

$ret = $vrf->verify_citizen_card_number( 'ob' => q{}  );
is( $ret, undef, 'verify_citizen_card_number no param, zeroed OB');

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => q{} );
is( $ret, 8004, 'verify_citizen_card_number ccnumber empty' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => 0 );
is( $ret, 8004, 'verify_citizen_card_number ccnumber zero' );

$ret = $vrf->verify_citizen_card_number(  'ob' => 1, 'ccnumber' => undef );
is( $ret, 8004, 'verify_citizen_card_number ccnumber undef' );

$ret = $vrf->verify_citizen_card_number(  'ob' => 1, 'ccnumber' => '+++---+12+3+' );
is( $ret, 8004, 'verify_citizen_card_number incorrect format number' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '012345678AA01');
is( $ret, 8004, 'verify_citizen_card_number too long' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '012345678AA' );
is( $ret, 8004, 'verify_citizen_card_number too short' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '0A23A5678AA1' );
is( $ret, 8004, 'verify_citizen_card_number invalid number' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '01234567BAA1' );
is( $ret, 8004, 'verify_citizen_card_number invalid check digit' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '012345678++1' );
is( $ret, 8004, 'verify_citizen_card_number invalid Version' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '012345678AAB' );
is( $ret, 8004, 'verify_citizen_card_number invalid check digit' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '012345678aa2' );
is( $ret, 8004, 'verify_citizen_card_number invalid' );

$ret = $vrf->verify_citizen_card_number( 'ccnumber' => '003300000112' );
is( $ret, 8005, 'verify_citizen_card_number invalid number' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '00000000 0 ZZ 4' );
is( $ret, 8004, 'verify_citizen_card_number invalid format' );

$ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => '000000000ZZ4' );
is( $ret, undef, 'verify_citizen_card_number valid dummy number' );

$ret = $vrf->verify_citizen_card_number( 'ccnumber' => '000000000ZZ4' );
is( $ret, undef, 'verify_citizen_card_number valid dummy number' );


# Valid number format tests (google rocks ;-) )

my @valid_numbers = qw/000000000ZZ4 084291753ZZ0 107902974ZZ2/;

for my $number ( @valid_numbers ) {
    $ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => $number );
    is( $ret, undef, "verify_citizen_card_number valid: $number" );
}

my @invalid_numbers = qw/000000000ZZ1 0003400002Z1 003300000112 0202000002Z1 000000000A81/;

for my $number ( @invalid_numbers ) {
    $ret = $vrf->verify_citizen_card_number( 'ob' => 1, 'ccnumber' => $number );
    is( $ret, 8005, "verify_citizen_card_number valid format but invalid citizen card number: $number" );
}

