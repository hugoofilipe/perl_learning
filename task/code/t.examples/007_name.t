#! ##### perlcritic go away

use strict;
use warnings;

use lib qw( /servers/libs/novis);
use Data::Dumper;

use Test::More tests => 11;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

diag "\ntests for verify_name";
$ret = $vrf->verify_name();
is( $ret, undef, 'no params' );

$ret = $vrf->verify_name( 'ob' => 1 );
is( $ret, 101, 'missing mandatory parameter' );

$ret = $vrf->verify_name( 'ob' => 1, 'name' => 'OneWord' );
is( $ret, 102, 'single word name fails' );

$ret = $vrf->verify_name( 'ob' => 1, 'name' => 'First1Name SecondName' );
is( $ret, 103, 'name with digit fails' );

$ret = $vrf->verify_name( 'ob' => 1, 'name' => 'FirstName SecondName' );
is( $ret, undef, 'valid name' );

diag "\ntests for verify_name_emp";
$ret = $vrf->verify_name_emp();
is( $ret, undef, 'no params' );

$ret = $vrf->verify_name_emp( 'ob' => 1 );
is( $ret, 101, 'missing mandatory parameter' );

$ret = $vrf->verify_name_emp( 'ob'   => 1,
                              'name' => 'FirstName SecondName and a D1git' );
is( $ret, undef, 'valid name' );

$ret = $vrf->verify_name( 'ob' => 1, 'name' => 'MIL E UM SNACK BAR LDA' );
is( $ret, undef, 'valid name: MIL E UM SNACK BAR LDA' );
