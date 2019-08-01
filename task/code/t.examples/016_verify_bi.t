#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 17;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# ------------------- no param ------------------- #

$ret = $vrf->verify_bi();
is( $ret, undef, 'no params: verify_bi' );


$ret = $vrf->verify_bi( 'ob' => 1 );
is( $ret, 1501, 'verify_bi: ob => 1' );

$ret = $vrf->verify_bi( 'ob' => 1, 'invalid_parameter' => 'invalid_parameter' );
is( $ret, 1501, 'verify_bi: ob => 1, invalid_parameter' );

$ret = $vrf->verify_bi( 'ob' => 1, 'number' => '0' );
is( $ret, 1501, 'verify_bi: number => 0 (false)' );


$ret = $vrf->verify_bi( 'number' => 'aaaaa', );
is( $ret, 1502, 'verify_bi: number => aaaaa' );

$ret = $vrf->verify_bi( 'number' => '23aaa434', );
is( $ret, 1502, 'verify_bi: number => 23aaa434' );


$ret = $vrf->verify_bi( 'number' => 234234234, );
is( $ret, 1503, 'verify_bi: number => 234234234, without date (dia/mes/ano)' );

$ret = $vrf->verify_bi( 'number' => 233234, 'dia' => 2, 'ano' => 3 );
is( $ret, 1503, 'verify_bi: number => 233234, date: 2/3 (without ano)' );



$ret = $vrf->verify_bi( 'ob' => 1, 'number' => 1234567890, );
is( $ret, 1505, 'verify_bi: number => 1234567890' ); #undef???

$ret = $vrf->verify_bi( 'ob' => 1, 'number' => '2aa33dd234', );
is( $ret, 1505, 'verify_bi: ob => 1, number => 2aa33dd234' ); #1502??

$ret = $vrf->verify_bi( 'ob' => 1, 'number' => 233234, 'dia' => 2, 'ano' => 3 );
is( $ret, 1505, 'verify_bi: ob => 1, number => 233234, date: 2/3 (without ano)' );

$ret = $vrf->verify_bi( 'ob' => 1, 'number' => '1234567890', 'entidade' => 4 );
is( $ret, 1503, 'verify_bi: number => 1234567890, entidade => 4 (without date)' );

$ret = $vrf->verify_bi( 'ob' => 1, 'number' => '1234567890', 'entidade' => 4, 'dia' => 2, 'mes' => 2, 'ano' => 2009);
is( $ret, undef, 'verify_bi: number => 1234567890, entidade => 4 (with date: 2/2/2009)' );

$ret = $vrf->verify_bi( 'ob' => 1, 'number' => '1234567890', 'entidade' => 4, 'dia' => 2, 'mes' => 3, 'ano' => 1800 );
is( $ret, 1504, 'verify_bi: number => 1234567890, entidade => 4 (with date: 2/2/1800)' );

$ret = $vrf->verify_bi( 'ob' => 1, 'number' => '1234567890', 'entidade' => 4, 'dia' => 7, 'mes' => 7, 'ano' => 2009 );
is( $ret, undef, 'verify_bi: number => 1234567890, entidade => 4 (with date: 7/7/2009)' );
