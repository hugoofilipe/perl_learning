#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 23;
use_ok('Novis::Verify');
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# ------------------- no param ------------------- #

$ret = $vrf->verify_data_nascimento();
is( $ret, undef, 'no params: verify_data_nascimento' );

$ret = $vrf->verify_data_nascimento( 'ob' => 1 );
is( $ret, 1601, 'verify_data_nascimento: ob => 1' );

$ret = $vrf->verify_data_nascimento( 'ob'                => 1,
                                     'invalid_parameter' => 'invalid_parameter'
);
is( $ret, 1601, 'verify_data_nascimento: ob => 1, invalid_parameter' );

$ret = $vrf->verify_data_nascimento( 'ob' => 1, 'ano' => '0' );
is( $ret, 1601, 'verify_data_nascimento: ano => 0 (false)' );

$ret = $vrf->verify_data_nascimento( 'ano' => 'aaaaa', );
is( $ret, 1601, 'verify_data_nascimento: ano => aaaaa' );

$ret = $vrf->verify_data_nascimento( 'ano' => '23aaa434', );
is( $ret, 1601, 'verify_data_nascimento: ano => 23aaa434' );

$ret = $vrf->verify_data_nascimento( 'ano' => 234234234, );
is( $ret, 1601, 'verify_data_nascimento: ano => 234234234' );

$ret = $vrf->verify_data_nascimento( 'ano' => 233234,
                                     'dia' => 2,
                                     'ano' => 3
);
is( $ret, 1601, 'verify_data_nascimento: date: 2/3/233234' );

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'ano' => 233234,
                                     'dia' => 2,
);
is( $ret, 1601, 'verify_data_nascimento: date: 2/?/233234 without month' );

$ret = $vrf->verify_data_nascimento( 'ob' => 1, 'ano' => 1234567890, );
is( $ret, 1601, 'verify_data_nascimento: ano => 1234567890' );

$ret = $vrf->verify_data_nascimento( 'ob' => 1, 'ano' => '2aa33dd234', );
is( $ret, 1601, 'verify_data_nascimento: ob => 1, ano => 2aa33dd234' );

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'dia' => 2,
                                     'mes' => 3
);
is( $ret, 1601,
    'verify_data_nascimento: ob => 1, with date: 2/3/?, without year'
);

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'ano' => '1234567890',
);
is( $ret, 1601,
    'verify_data_nascimento: ano => 1234567890, entidade => 4 (without date)'
);

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'dia' => 2,
                                     'mes' => 2,
                                     'ano' => 2009
);
is( $ret, 1603,
    'verify_data_nascimento: sem idade minima (with date: 2/2/2009)'
);

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'dia' => 2,
                                     'mes' => 3,
                                     'ano' => 1800,
);
is( $ret, 1602,
    'verify_data_nascimento: ano < 1850 (with date: 2/3/1800)'
);

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'dia' => 2,
                                     'mes' => 3,
                                     'ano' => 2001,
);
is( $ret, 1603,
    'verify_data_nascimento: sem idade minima (with date: 2/3/2001)'
);

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'dia' => 2,
                                     'mes' => 3,
                                     'ano' => 1940,
);
is( $ret, undef, 'verify_data_nascimento: with date: 2/3/1940');

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'dia' => 2,
                                     'mes' => 3,
                                     'ano' => 1930,
);
is( $ret, undef, 'verify_data_nascimento: with date: 2/3/1930');


$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'dia' => 2,
                                     'mes' => 3,
                                     'ano' => 1990,
);
is( $ret, undef, 'verify_data_nascimento: with date: 2/3/1990');

$ret = $vrf->verify_data_nascimento( 'ob'  => 1,
                                     'dia' => 2,
                                     'mes' => 13,
                                     'ano' => 1990,
);
is( $ret, 1602,
    'verify_data_nascimento: ano => 1234567890 (with incorrect month in date: 2/13/1990)'
);



