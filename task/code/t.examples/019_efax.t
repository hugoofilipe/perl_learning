#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 21;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# ------------------- no param ------------------- #

$ret = $vrf->verify_efax();
is( $ret, 1801, 'no params: verify_efax' );

$ret = $vrf->verify_efax( 'ob' => 1 );
is( $ret, 1801, 'verify_efax: ob => 1, invalid parameter' );

$ret = $vrf->verify_efax( 'ob' => 1, 'invalid_parameter' => 'invalid_parameter' );
is( $ret, 1801, 'verify_efax: with invalid_parameters' );

$ret = $vrf->verify_efax( 'title' => 'My title', );
is( $ret, 1801, 'verify_efax: valid title (missing parameters)' );

$ret = $vrf->verify_efax( 'first_name' => 'FirstName', );
is( $ret, 1801, 'verify_efax: valid first name (missing parameters)' );

$ret = $vrf->verify_efax( 'last_name' => 'LastName', );
is( $ret, 1801, 'verify_efax: valid last name (missing parameters)' );

$ret = $vrf->verify_efax( 'email' => 'FirstName@email.pt', );
is( $ret, 1801, 'verify_efax: valid email (missing parameters)' );

$ret = $vrf->verify_efax( 'organization' => 'My organization', );
is( $ret, 1801, 'verify_efax: valid organization (missing parameters)' );

$ret = $vrf->verify_efax( 'prefix' => 'prefix', );
is( $ret, 1801, 'verify_efax: valid prefix (missing parameters)' );

$ret = $vrf->verify_efax( 'organization' => 'My organization', 'title' => 'title');
is( $ret, 1801, 'verify_efax: valid organization and title (missing parameters)' );

$ret = $vrf->verify_efax( 'prefix' => 'prefix', 'first_name' => 'FirstName' );
is( $ret, 1801, 'verify_efax: valid prefix and first_name (missing parameters)' );



$ret = $vrf->verify_efax( 'title'        => 'title',
                          'first_name'   => 'Peter',
                          'last_name'    => 'Wall',
                          'email'        => 'valid_email@email.pt',
                          'organization' => 'ISP',
                          'prefix'       => 'pre'
);
is( $ret, 1807, 'verify_efax: prefix not number' );

$ret = $vrf->verify_efax( 'title'        => 'title',
                          'first_name'   => 'Peter',
                          'last_name'    => 'Wall',
                          'email'        => 'valid_email@email.pt',
                          'organization' => 'ISP',
                          'prefix'       => '234'
);
is( $ret, undef, 'verify_efax: correct data' );

$ret = $vrf->verify_efax( 'title'        => 'title 1233',
                          'first_name'   => '*Peter',
                          'last_name'    => '* _Wall',
                          'email'        => 'valid_email@email.pt',
                          'organization' => 'ISP',
                          'prefix'       => 'pre'
);
is( $ret, 1803, 'verify_efax: prefix not number' );

$ret = $vrf->verify_efax( 'title'        => 'title',
                          'first_name'   => 'Peter',
                          'last_name'    => '* _Wall',
                          'email'        => 'valid_email@email.pt',
                          'organization' => 'ISP',
                          'prefix'       => '234'
);
is( $ret, 1804, 'verify_efax: first name with chars invalid' );

$ret = $vrf->verify_efax( 'title'        => 'title',
                          'first_name'   => 'Peter',
                          'last_name'    => 'Wall',
                          'email'        => '\@email.pt',
                          'organization' => '123',
                          'prefix'       => '3'
);
is( $ret, 1805, 'verify_efax: email is invalid' );

$ret = $vrf->verify_efax( 'title'        => 't3 itle',
                          'first_name'   => 'Peqqq ter',
                          'last_name'    => 'Walqq l',
                          'email'        => 'valid_email@email.pt',
                          'organization' => 'ISP',
                          'prefix'       => '234'
);
is( $ret, undef, 'verify_efax: correct data' );

$ret = $vrf->verify_efax( 'title'        => 't3 itle',
                          'first_name'   => 'Peqqqer',
                          'last_name'    => 'Wall',
                          'email'        => 'valid_email@email.pt',
                          'organization' => '\\$\\$ **ISP',
                          'prefix'       => '234'
);
is( $ret, 1806, 'verify_efax: organization invalid' );

$ret = $vrf->verify_efax( 'title'        => '### ***',
                          'first_name'   => '*Peter',
                          'last_name'    => '* _Wall',
                          'email'        => 'valid_email@email.pt',
                          'organization' => 'ISP',
                          'prefix'       => 'pre'
);
is( $ret, 1802, 'verify_efax: invalid title' );



