#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 20;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );


$ret = $vrf->pin_verify();
is( $ret, 7001, 'no params: pin_verify' );

$ret = $vrf->pin_verify( 'invalid' => 1 );
is( $ret, 7001, 'pin_verify: invalid parameter => 1' );

$ret = $vrf->pin_verify( 'new_pin' => 1, 'conf_new_pin' => 'pin' );
is( $ret, 7001, 'pin_verify: new_pin => 1, conf_new_pin => pin' );

$ret = $vrf->pin_verify( 'new_pin' => 1, 'conf_new_pin' => 'pin', 'pin_actual' => 1231 );
is( $ret, 7001, 'pin_verify: new_pin => 1, conf_new_pin => pin, pin_actual => 1231' );

$ret = $vrf->pin_verify( 'new_pin' => 1, 'conf_new_pin' => 'pin', 'pin' => 1232 );
is( $ret, 7001, 'pin_verify: new_pin => 1, conf_new_pin => pin, pin => 1232' );

$ret = $vrf->pin_verify( 'new_pin' => 1, 'conf_new_pin' => 'pin' );
is( $ret, 7001, 'pin_verify: new_pin => 1, conf_new_pin => pin' );

$ret = $vrf->pin_verify( 'pin' => 1, 'pin_actual' => 'Quem' );
is( $ret, 7001, 'pin_verify: pin => 1, pin_actual => Quem' );

$ret = $vrf->pin_verify( 'new_pin' => 21, 'conf_new_pin' => 21 );
is( $ret, 7001, 'pin_verify: new_pin => 21, conf_new_pin => 21');



$ret = $vrf->pin_verify( 'new_pin' => 4121, 'conf_new_pin' => 3114, 'pin' => 1234, 'pin_actual' => 1234 );
is( $ret, 7002, 'pin_verify: new_pin => 4121, conf_new_pin => 3114, pin => 1234, pin_actual => 1234' );


$ret = $vrf->pin_verify( 'new_pin' => 'aaaa', 'conf_new_pin' => 'aaa', 'pin' => 1234, 'pin_actual' => 12 );
is( $ret, 7003, 'pin_verify: new_pin => aaaa, conf_new_pin => aaa, pin => 1234, pin_actual => 12' );

$ret = $vrf->pin_verify( 'new_pin' => 21, 'conf_new_pin' => 22, 'pin' => 1234, 'pin_actual' => 12 );
is( $ret, 7003, 'pin_verify: new_pin => 21, conf_new_pin => 22, pin => 1234, pin_actual => 12' );

$ret = $vrf->pin_verify( 'new_pin' => 'same', 'conf_new_pin' => 'same', 'pin' => 1234, 'pin_actual' => 12 );
is( $ret, 7003, 'pin_verify: new_pin => same, conf_new_pin => same, pin => 1234, pin_actual => 12' );

$ret = $vrf->pin_verify( 'new_pin' => 21, 'conf_new_pin' => 21, 'pin' => 1234, 'pin_actual' => 12 );
is( $ret, 7003, 'pin_verify: new_pin => 21, conf_new_pin => 22, pin => 1234, pin_actual => 12' );

$ret = $vrf->pin_verify( 'new_pin' => 123456, 'conf_new_pin' => 123456, 'pin' => 1234, 'pin_actual' => 12 );
is( $ret, 7003, 'pin_verify: new_pin => 123456, conf_new_pin => 123456, pin => 1234, pin_actual => 12' );


$ret = $vrf->pin_verify( 'new_pin' => 1234, 'conf_new_pin' => 1234, 'pin' => 4321, 'pin_actual' => 1234 );
is( $ret, 7004, 'pin_verify: new_pin => 1234, conf_new_pin => 1234, pin => 4321, pin_actual => 1234' );

$ret = $vrf->pin_verify( 'new_pin' => 1234, 'conf_new_pin' => 1234, 'pin' => 44332211, 'pin_actual' => 11223344 );
is( $ret, 7004, 'pin_verify: new_pin => 1234, conf_new_pin => 1234, pin => 44332211, pin_actual => 11223344' );


$ret = $vrf->pin_verify( 'new_pin' => 1234, 'conf_new_pin' => 1234, 'pin' => 1234, 'pin_actual' => 1234 );
is( $ret, undef, 'pin_verify: new_pin => 1234, conf_new_pin => 1234, pin => 1234, pin_actual => 1234' );

$ret = $vrf->pin_verify( 'new_pin' => 1234, 'conf_new_pin' => 1234, 'pin' => 11223344, 'pin_actual' => 11223344 );
is( $ret, undef, 'pin_verify: new_pin => 1234, conf_new_pin => 1234, pin => 11223344, pin_actual => 11223344' );


