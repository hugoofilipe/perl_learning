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

$ret = $vrf->verify_fax();
is( $ret, undef, 'no params yields valid fax');
 
$ret = $vrf->verify_fax('ob' => 1);
is( $ret, 601, 'mandatory parameter not given');

$ret = $vrf->verify_fax('ob' => 1, 'fax' => '123450000');
is( $ret, 604, 'fax number cannot end in 0000');

$ret = $vrf->verify_fax('ob' => 1, 'fax' => '1234a6789');
is( $ret, 605, 'fax number has to be comprised only of digits');

$ret = $vrf->verify_fax('ob' => 1, 'fax' => '123456789');
is( $ret, undef, 'valid fax yields undef (valid input)');







