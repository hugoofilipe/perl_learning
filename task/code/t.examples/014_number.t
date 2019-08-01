#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 13;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# ------------------- no param ------------------- #

$ret = $vrf->verify_number();
is( $ret, undef, 'no params: verify_number' );

$ret = $vrf->verify_number( 'ob' => 1 );
is( $ret, 1101, 'verify_number: ob => 1' );

$ret = $vrf->verify_number( 'ob' => 1, 'invalid_parameter' => 'invalid_parameter' );
is( $ret, 1101, 'verify_number: with invalid_parameters' );

$ret = $vrf->verify_number( 'number' => 234234234, );
is( $ret, undef, 'verify_number: valid number => 234234234' );

$ret = $vrf->verify_number( 'number' => 'aaaaa', );
is( $ret, 1102, 'verify_number: with invalid number (aaaaa)' );

$ret = $vrf->verify_number( 'number' => '23aaa434', );
is( $ret, 1102, 'verify_number: with invalid number (23aaa434)' );

$ret = $vrf->verify_number( 'ob' => 1, 'number' => '2aa33dd234', );
is( $ret, 1102, 'verify_number: with invalid number (2aa33dd234)' );

$ret = $vrf->verify_number( 'ob' => 1, 'number' => '233234', );
is( $ret, undef, 'verify_number: with valid parameters' );

$ret = $vrf->verify_number( 'ob' => 1, 'number' => '1234567890', );
is( $ret, undef, 'verify_number: with valid parameters (number = 1234567890)' );

$ret = $vrf->verify_number( 'ob' => 1, 'number' => '0' );
is( $ret, 1101, 'verify_number: number => 0 (false)' );

$ret = $vrf->verify_number( 'ob' => 1, 'number' => 1234567890, );
is( $ret, undef, 'verify_number: number => 1234567890' );
