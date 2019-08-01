#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 24;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# ------------------- no param ------------------- #

$ret = $vrf->verify_bi_data_nascimento();
is( $ret, undef, 'no params: verify_bi_data_nascimento' );

$ret = $vrf->verify_bi_data_nascimento( 'ob' => 1 );
is( $ret, 1501, 'verify_bi_data_nascimento: ob => 1' );

$ret = $vrf->verify_bi_data_nascimento(
                                      'ob'                => 1,
                                      'invalid_parameter' => 'invalid_parameter'
);
is( $ret, 1501, 'verify_bi_data_nascimento: ob => 1, invalid_parameter' );

$ret = $vrf->verify_bi_data_nascimento( 'ob' => 1, 'number' => '0' );
is( $ret, 1501, 'verify_bi_data_nascimento: number => 0 (false)' );

$ret = $vrf->verify_bi_data_nascimento( 'number' => 'aaaaa', );
is( $ret, 1502, 'verify_bi_data_nascimento: number => aaaaa' );

$ret = $vrf->verify_bi_data_nascimento( 'number' => '23aaa434', );
is( $ret, 1502, 'verify_bi_data_nascimento: number => 23aaa434' );

$ret = $vrf->verify_bi_data_nascimento( 'number' => 234234234, );
is( $ret, 1503,
    'verify_bi_data_nascimento: number => 234234234, without date (dia_bi/mes_bi/ano_bi)'
);

$ret = $vrf->verify_bi_data_nascimento( 'number' => 233234,
                                        'dia_bi' => 2,
                                        'ano_bi' => 3
);
is( $ret, 1503,
    'verify_bi_data_nascimento: number => 233234, date: 2/3 (without ano_bi)' );

$ret = $vrf->verify_bi_data_nascimento( 'ob' => 1, 'number' => 1234567890, );
is( $ret, 1505, 'verify_bi_data_nascimento: number => 1234567890' );   #undef???

$ret = $vrf->verify_bi_data_nascimento( 'ob' => 1, 'number' => '2aa33dd234', );
is( $ret, 1505, 'verify_bi_data_nascimento: ob => 1, number => 2aa33dd234' )
    ;                                                                  #1502??

$ret = $vrf->verify_bi_data_nascimento( 'ob'     => 1,
                                        'number' => 233234,
                                        'dia_bi' => 2,
                                        'ano_bi' => 3
);
is( $ret, 1505,
    'verify_bi_data_nascimento: ob => 1, number => 233234, date: 2/3 (without year)'
);

$ret = $vrf->verify_bi_data_nascimento( 'ob'       => 1,
                                        'number'   => '1234567890',
                                        'entidade' => 4
);
is( $ret, 1503,
    'verify_bi_data_nascimento: number => 1234567890, entidade => 4 (without date)'
);

$ret = $vrf->verify_bi_data_nascimento( 'ob'       => 1,
                                        'number'   => '1234567890',
                                        'entidade' => 4,
                                        'dia_bi'   => 2,
                                        'mes_bi'   => 2,
                                        'ano_bi'   => 2009
);
is( $ret, 1506,
    'verify_bi_data_nascimento: number => 1234567890, entidade => 4 (with date: 2/2/2009, without \"Data de Nascimento\")'
);

$ret = $vrf->verify_bi_data_nascimento( 'ob'       => 1,
                                        'entidade' => 4,
                                        'dia_bi'   => 2,
                                        'mes_bi'   => 2,
                                        'ano_bi'   => 2009
);
is( $ret, 1501,
    'verify_bi_data_nascimento: without number'
);

$ret = $vrf->verify_bi_data_nascimento( 'entidade' => 4,
                                        'dia_bi'   => 2,
                                        'mes_bi'   => 2,
                                        'ano_bi'   => 2009
);
is( $ret, undef,
    'verify_bi_data_nascimento: without number and OB'
);

$ret = $vrf->verify_bi_data_nascimento( 'ob'       => 1,
                                        'number'   => 21212324,
                                        'dia_bi'   => 2,
                                        'mes_bi'   => 2,
                                        'ano_bi'   => 2009
);
is( $ret, 1505,
    'verify_bi_data_nascimento: without entidade'
);

$ret = $vrf->verify_bi_data_nascimento( 'number'   => 21212324,
                                        'dia_bi'   => 2,
                                        'mes_bi'   => 2,
                                        'ano_bi'   => 2009
);
is( $ret, undef,
    'verify_bi_data_nascimento: without number and OB'
);

$ret = $vrf->verify_bi_data_nascimento( 'ob'             => 1,
                                        'number'         => '1234567890',
                                        'entidade'       => 4,
                                        'dia_bi'         => 2,
                                        'mes_bi'         => 3,
                                        'ano_bi'         => 1800,
                                        'dia_nascimento' => 4,
                                        'mes_nascimento' => 3,
                                        'ano_nascimento' => 1970
);
is( $ret, 1504,
    'verify_bi_data_nascimento: number => 1234567890, entidade => 4 (with date: 2/2/1800)'
);

$ret = $vrf->verify_bi_data_nascimento( 'ob'       => 1,
                                        'number'   => '1234567890',
                                        'entidade' => 4,
                                        'dia_bi'         => 2,
                                        'mes_bi'         => 3,
                                        'ano_bi'         => 2001,
                                        'mes_nascimento' => 3,
                                        'ano_nascimento' => 1970
);
is( $ret, 1506,
    'verify_bi_data_nascimento: number => 1234567890, entidade => 4 (with date: 7/7/2009)'
);

$ret = $vrf->verify_bi_data_nascimento( 'ob'       => 1,
                                        'number'   => '1234567890',
                                        'entidade' => 4,
                                        'dia_bi'         => 2,
                                        'mes_bi'         => 3,
                                        'ano_bi'         => 1940,
                                        'ano_nascimento' => 1970
);
is( $ret, 1506,
    'verify_bi_data_nascimento: number => 1234567890, entidade => 4 (with date: 7/7/2009)'
);

$ret = $vrf->verify_bi_data_nascimento( 'ob'       => 1,
                                        'number'   => '1234567890',
                                        'entidade' => 4,
                                        'dia_bi'         => 2,
                                        'mes_bi'         => 3,
                                        'ano_bi'         => 1930,
                                        'mes_nascimento' => 3,
);
is( $ret, 1506,
    'verify_bi_data_nascimento: number => 1234567890, entidade => 4 (with date: 7/7/2009)'
);


$ret = $vrf->verify_bi_data_nascimento( 'ob'             => 1,
                                        'number'         => '1234567890',
                                        'entidade'       => 4,
                                        'dia_bi'         => 2,
                                        'mes_bi'         => 3,
                                        'ano_bi'         => 2002,
                                        'dia_nascimento' => 4,
                                        'mes_nascimento' => 3,
                                        'ano_nascimento' => 1970
);
is( $ret, undef,
    'verify_bi_data_nascimento: number => 1234567890, entidade => 4 (with date: 2/2/1800)'
);

# dates are not currently tested
#$ret = $vrf->verify_bi_data_nascimento( 'ob'             => 1,
#                                        'number'         => '1234567890',
#                                        'entidade'       => 4,
#                                        'dia_bi'         => 2,
#                                        'mes_bi'         => 13,
#                                        'ano_bi'         => 2001,
#                                        'dia_nascimento' => 4,
#                                        'mes_nascimento' => 3,
#                                        'ano_nascimento' => 1970
#);
#is( $ret, 1504,
#    'verify_bi_data_nascimento: number => 1234567890, entidade => 4 (with incorrect month in date: 2/13/2001)'
#);



