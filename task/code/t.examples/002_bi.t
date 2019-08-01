#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More tests => 9;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

$ret = $vrf->verify_bi_number();
is( $ret, undef, 'no params given' );

my @bis_ok = qw/0830632 7327382 0001682/;

for my $bi ( @bis_ok ) {
    my $ret = $vrf->verify_bi_number( 'number' => $bi );
    is( $ret, undef, "number => $bi" );
}

my $invalid = '7327382123344';
$ret = $vrf->verify_bi_number( 'number' => $invalid );
is( $ret, 1102, 'number too long' );

$invalid = '12abcde12';
$ret = $vrf->verify_bi_number( 'number' => $invalid );
is( $ret, 1102, 'number with alphabetic chars' );

$ret = $vrf->verify_bi_number( 'ob' => 1 );
is( $ret, 1101, 'no number with ob flag' );

