#! ##### perlcritic go away

use strict;
use warnings;

use lib qw( /servers/libs/novis);
use Data::Dumper;

use Test::More tests => 6;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# diag "\ntests for verify_name";
$ret = $vrf->verify_address();
is( $ret, undef, 'no params');

$ret = $vrf->verify_address('ob' => 1);
is( $ret, 201, 'missing mandatory parameter');

$ret = $vrf->verify_address('ob' => 1, 'address' => "x"x121);
is( $ret, 202, 'long address fails');

$ret = $vrf->verify_address('ob' => 1, 'address' => 'Rua dos Testes, 1Â dto');
is( $ret, undef, 'valid address passes');



