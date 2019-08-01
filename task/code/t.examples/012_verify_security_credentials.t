#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 10;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# ------------------- no param ------------------- #

$ret = $vrf->verify_security_credentials();
is( $ret, undef, 'no params: verify_security_credentials' );

$ret = $vrf->verify_security_credentials( 'ob' => 1 );
is( $ret, 1901, 'verify_security_credentials: ob => 1' );

$ret = $vrf->verify_security_credentials( 'ob' => 1, 'answer' => 'Resposta' );
is( $ret, 1902, 'verify_security_credentials: invoking only the parameter answer' );

$ret = $vrf->verify_security_credentials( 'ob' => 1, 'question' => 'Quem' );
is( $ret, 1903, 'verify_security_credentials: invoking only the parameter question' );

$ret = $vrf->verify_security_credentials( 'ob' => 1, 'answer' => 'Resposta', 'question' => 'Quem' );
is( $ret, undef, 'verify_security_credentials: invoking with parameters valid' );

$ret = $vrf->verify_security_credentials( 'ob' => 1, 'question' => ' With space', 'answer' => 'bla bla');
is( $ret, undef, 'verify_security_credentials: invoking with parameters valid (question begining with space, answer with spaces)' );

$ret = $vrf->verify_security_credentials( 'ob' => 1, 'question' => '  ', 'answer' => 'Answer');
is( $ret, 1904, 'verify_security_credentials: invoking with question invalid and correct answer' );

$ret = $vrf->verify_security_credentials( 'answer' => ' ', 'question' => 'question');
is( $ret, 1905, 'verify_security_credentials: invoking with answer invalid and correct question' );

