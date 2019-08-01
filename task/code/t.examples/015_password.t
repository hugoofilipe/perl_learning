#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 22;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# ------------------- no param ------------------- #

$ret = $vrf->verify_password();
is( $ret, undef, 'no params: verify_password' );

$ret = $vrf->verify_password( 'ob' => 1 );
is( $ret, 1201, 'verify_password: ob => 1' );

$ret = $vrf->verify_password( 'ob' => 1, 'invalid_parameter' => 'invalid_parameter' );
is( $ret, 1201, 'verify_password: ob => 1, invalid_parameter' );

$ret = $vrf->verify_password( 'password' => 234234234, );
is( $ret, 1202, 'verify_password: password => 234234234' );

$ret = $vrf->verify_password( 'password' => 'aaaaa', );
is( $ret, undef, 'verify_password: password => aaaaa' );

$ret = $vrf->verify_password( 'password' => '23aaa434', );
is( $ret, undef, 'verify_password: password => 23aaa434' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '2aa33dd234', );
is( $ret, 1202, 'verify_password: ob => 1, password => 2aa33dd234' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '233234', );
is( $ret, undef, 'verify_password: ob => 1, password => 233234' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '12aaaee890', );
is( $ret, 1202, 'verify_password: password => 12aaaee890' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '0' );
is( $ret, 1201, 'verify_password: password => 0 (false)' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => 1234560, );
is( $ret, undef, 'verify_password: password => 1234560' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => ']%12', );
is( $ret, undef, 'verify_password: password => ]%12' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '1[0', );
is( $ret, 1203, 'verify_password: password => 1[0' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '', );
is( $ret, 1201, 'verify_password: with ob => 1, password => (vazio)' );

$ret = $vrf->verify_password( 'password' => q{}, );
is( $ret, undef, 'verify_password: password => (vazio)' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '    ', );
is( $ret, 1204, 'verify_password: password => (with 4 spaces)' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => ' ', );
is( $ret, 1203, 'verify_password: password => (with 1 space)' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '(  a a)', );
is( $ret, 1204, 'verify_password: password => (  a a) [with spaces]' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => '********', );
is( $ret, 1205, 'verify_password: password => ********' );

$ret = $vrf->verify_password( 'ob' => 1, 'password' => 'antuaç', );
is( $ret, 1205, 'verify_password: password => antuaç' );


