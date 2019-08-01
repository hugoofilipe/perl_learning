#! ##### perlcritic go away

use strict;
use warnings;

use lib qw( /servers/libs/novis);
use Data::Dumper;

use Test::More tests => 20;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

$ret = $vrf->verify_fiscal_number();
is( $ret, undef, 'no params given' );

$ret = $vrf->verify_fiscal_number( 'ob' => 1 );
is( $ret, 801, 'no params given with ob flag' );

$ret = $vrf->verify_fiscal_number( 'fiscal_number' => '000000000' );
is( $ret, 803, 'fail nif == 000000000' );

$ret = $vrf->verify_fiscal_number( 'fiscal_number' => '123456789' );
is( $ret, 803, 'fail nif == 123456789' );

my @nifs_nok = ( '188698565', );

for my $nif ( @nifs_nok ) {
    my $ret = $vrf->verify_fiscal_number( 'fiscal_number' => $nif );
    is( $ret, 803, "number => $nif" );
}

my @nifs_ok = qw(
    116465379
    199169268
    188898565
);

#223892463, #might be an exceptio, wait for the image of nif card

for my $nif ( @nifs_ok ) {
    my $ret = $vrf->verify_fiscal_number( 'fiscal_number' => $nif );
    is( $ret, undef, "number => $nif" );
}

# Business validator

$ret = $vrf->verify_fiscal_number_emp();
is( $ret, undef, 'emp no params given' );

$ret = $vrf->verify_fiscal_number_emp( 'ob' => 1 );
is( $ret, 801, 'emp no params given with ob flag' );

push @nifs_ok, 'PT116465379';
push @nifs_ok, 'AT116465379';    #austrian 'nif' -> just look at first 2 letters

for my $nif ( @nifs_ok ) {
    my $ret = $vrf->verify_fiscal_number_emp( 'fiscal_number' => $nif );
    is( $ret, undef, "emp number => $nif" );
}

$ret = $vrf->verify_fiscal_number_emp( 'fiscal_number' => 'XX123456789' );
is( $ret, 803, 'emp non existing tld XX' );

$ret = $vrf->verify_fiscal_number_emp( 'fiscal_number' => 'PT' );
is( $ret, 803, 'emp invalid formated business nif PT' );

$ret = $vrf->verify_fiscal_number_emp( 'fiscal_number' => 'AT' );
is( $ret, 803, 'emp invalid formated business nif AT' );

