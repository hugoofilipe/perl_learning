#! ##### perlcritic go away

use strict;
use warnings;

use lib qw( /servers/libs/novis);
use Data::Dumper;

# use Test::More tests => 20;
use Test::More qw( no_plan );
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

diag 'zip1 tests';
$ret = $vrf->verify_zip1();
is( $ret, undef, 'no params yields valid address');
 
$ret = $vrf->verify_zip1('ob' => 1);
is( $ret, 301, 'mandatory parameter not given');

$ret = $vrf->verify_zip1('ob' => 1, 'zip1' => '012345');
is( $ret, 302, 'zip1 starting with zero is invalid');

$ret = $vrf->verify_zip1('ob' => 1, 'zip1' => '123');
is( $ret, 302, 'zip1 with less than 4 digits is invalid');

$ret = $vrf->verify_zip1('ob' => 1, 'zip1' => '12345');
is( $ret, 302, 'zip1 with more than 4 digits is invalid');

$ret = $vrf->verify_zip1('ob' => 1, 'zip1' => '1234');
is( $ret, undef, 'valid zip1 yields undef (valid input)');

diag 'zip2 tests';

$ret = $vrf->verify_zip2();
is( $ret, undef, 'no params yields valid address');
 
$ret = $vrf->verify_zip2('ob' => 1);
is( $ret, 303, 'mandatory parameter not given');

$ret = $vrf->verify_zip2('ob' => 1, 'zip2' => '12');
is( $ret, 304, 'zip2 with less than 3 digits is invalid');

$ret = $vrf->verify_zip2('ob' => 1, 'zip2' => '1234');
is( $ret, 304, 'zip2 with more than 3 digits is invalid');

$ret = $vrf->verify_zip2('ob' => 1, 'zip2' => '123');
is( $ret, undef, 'valid zip2 yields undef (valid input)');

diag 'complete zip (zip1-zip2) tests';
$ret = $vrf->verify_zip();
is( $ret, undef, 'no params yields valid address');

$ret = $vrf->verify_zip('ob' => 1);
is( $ret, 301, 'mandatory parameter not given');

$ret = $vrf->verify_zip('ob' => 1, 'zip' => '1234*123');
is( $ret, 302, 'mandatory correct zip1 and zip2 with invalid separator yields error');

$ret = $vrf->verify_zip('ob' => 1, 'ob_zip2' => 0, 'zip' => '1234*');
is( $ret, 302, 'mandatory correct zip1 and non mandatory zip2 with invalid separator yields error');

$ret = $vrf->verify_zip('ob' => 1, 'ob_zip2' => 0, 'zip' => '1234-');
is( $ret, 302, 'mandatory correct zip1 and non mandatory zip2 with valid separator yields error');

$ret = $vrf->verify_zip('ob' => 1, 'zip' => '1234-567');
is( $ret, undef, 'valid zip yields undef (valid input)');


# HOW TO CATCH ERROR 305?!?!?!





