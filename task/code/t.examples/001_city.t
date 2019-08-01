#! ##### perlcritic go away

use strict;
use warnings;

use utf8;

use lib qw( /servers/libs/novis);
use Data::Dumper;

use Test::More 'tests' => 13;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

$ret = $vrf->verify_city();
is( $ret, undef, 'no params');
 
$ret = $vrf->verify_city('ob' => 1);
is( $ret, 401, 'missing mandatory parameter');

$ret = $vrf->verify_city('ob' => 1, 'city' => '-City-of-Tests');
is( $ret, 402, 'dash(-) in begining of City Name fails');

$ret = $vrf->verify_city('ob' => 1, 'city' => '\City-of-Tests');
is( $ret, 402, 'Invalid City Name (\City-of-Tests) yields error');

$ret = $vrf->verify_city('ob' => 1, 'city' => '$City-of-Tests');
is( $ret, 402, 'dollar ($) in City Name fails');

$ret = $vrf->verify_city('ob' => 1, 'city' => 'City-of-Tests -');
is( $ret, 402, 'dash(-) in end of City Name fails');

$ret = $vrf->verify_city('ob' => 1, 'city' => '** City');
is( $ret, 402, 'star (*) in City Name fails');

$ret = $vrf->verify_city('ob' => 1, 'city' => 'City-of*Tests');
is( $ret, 402, 'star (*) in City Name fails');


$ret = $vrf->verify_city('ob' => 1, 'city' => ' Lisboa');
is( $ret, 402, 'space in begining of City Name fails');

$ret = $vrf->verify_city('ob' => 1, 'city' => 'Lisboa ');
is( $ret, 402, 'space at end of City Name fails');

my $city = 'Famões';
#$city = 'Famoes';
$ret = $vrf->verify_city('ob' => 1, 'city' => $city);
is( $ret, undef, 'City with tilde:' . $city);

#$ret = $vrf->verify_city('ob' => 1, 'city' => 'Lisboa)))))');
#is( $ret, 402, 'space at end of City Name fails');



