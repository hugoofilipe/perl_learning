#! ##### perlcritic go away

use strict;
use warnings;

use lib qw(
    /servers/libs/novis
);
use Data::Dumper;

use Test::More 'tests' => 91;
require_ok( 'Novis::Verify' );

my $ret;

my $vrf = Novis::Verify->new();
isa_ok( $vrf, 'Novis::Verify' );

# ------------------- BEGIN empty/no param ------------------- #

$ret = $vrf->verify_email();
is( $ret, undef, 'no params: verify_email' );

$ret = $vrf->verify_email( 'email' => q{} );
is( $ret, undef, 'verify_email with empty email and no flag ob' );

$ret = $vrf->verify_alias();
is( $ret, undef, 'no params: verify_alias' );

$ret = $vrf->verify_email( 'ob' => 1 );
is( $ret, 701, 'no params with ob: verify_email' );

$ret = $vrf->verify_email( 'ob' => 1, 'email' => q{} );
is( $ret, 701, 'verify_email empty email' );

$ret = $vrf->mail_aliases_verify();
is( $ret, 53, 'no params: mail_aliases_verify' );

$ret = $vrf->mail_aliases_verify( 'ob' => 1 );
is( $ret, 53, 'no params with ob: mail_aliases_verify' );

$ret = $vrf->verify_alias( 'ob' => 1 );
is( $ret, 1301, 'no params with ob flag: verify_alias' );

# ------------------- END empty/no param ------------------- #

# ------------------- BEGIN valid email ------------------- #

my @valid_emails = qw(
    aaa@bbb.pt
    a.aa@bbb.pt
    alias_a@clix.pt
    jcp@domain.name.name.name.name
    jcp@domain.isp.pt
    qwertyuiopasdfghjklzxcvbnmqwerq@clix.pt
    nuno__silva@clix.pt
);

for my $email ( @valid_emails ) {
    my $ret = $vrf->verify_email( 'ob' => 1, 'email' => $email );
    is( $ret, undef, "verify_email: valid email '$email'" );
}

for my $email ( @valid_emails ) {
    my $ret = $vrf->mail_aliases_verify( 'ob' => 1, 'mail_aliases' => $email );
    is( $ret, 0, "mail_aliases_verify: valid email '$email'" );
}

$ret = $vrf->mail_aliases_verify( 'ob' => 1, 'mail_aliases' => \@valid_emails );
is( $ret, 0, "mail_aliases_verify: list of valid emails" );

my @valid_aliases = qw(
    aaa
    a.aa
    alias_a
    a_a
    aa--.pt
    aaa.t
    nuno__silva
);

for my $alias ( @valid_aliases ) {
    my $ret = $vrf->verify_alias( 'ob' => 1, 'mail_aliases' => $alias );
    is( $ret, undef, "verify_alias: valid alias '$alias'" );
}

# ------------------- valid alias by external systems ------------------ #
my @external_valid = qw( pab-@hotmail.com pb_br-ba-@hotmail.com p@hotmail.com );


for my $email ( @external_valid ) {
    my $ret = $vrf->verify_email_contact( 'ob' => 1, 'email' => $email );
    is( $ret, undef, "verify_email: valid external email '$email'" );
}


$ret = $vrf->verify_email_contact( 'ob' => 1, 'email' => 'pab-@hotmail.com' );
is( $ret, undef,
    'verify_email_contact email: pab-@hotmail.com (external email)' );

$ret = $vrf->verify_email_contact( 'ob' => 1,
                                   'email' => 'pb_br-ba-@hotmail.com' );
is( $ret, undef,
    'verify_email_contact email: pb_br-ba-@hotmail.com (external email)' );

$ret = $vrf->verify_email_contact( 'ob' => 1, 'email' => 'p@hotmail.com' );
is( $ret, undef, 'verify_email_contact email: p@hotmail.com (external email)' );


# ------------------- END valid email ------------------- #

# ------------------- BEGIN invalid email tests ------------------- #

my @spaces = ( ' aaa@bbb.pt ', 'aaa@bbb.pt ', ' aaa@bbb.pt', 'a aa@bbb.pt', );

my @invalid_emails = ( 'a_a@bbb_pt',
                       'a%$@abb_pt',
                       'alias#Ãa@clix.pt',
                       'aa@a...pt',
                       'aa@a--.pt',
                       'jcp@domain',                               #syntax
                       'jcp@um.sufixomesmomuitoinvalido',          #syntax
                       'jcp@um.sufixomesmomuitoinvalido.ptprr',    #suffix
                       'jcp@@.pt',
                       'jcp@ii@.pt',
                       'aa@a--.pt',
                       'pab-@hotmail.com',
);

my @invalid_alias = (
            'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq2saaa',
            ' aaa ',
            ' aaa',
            'aaa ',
            'a aa',
            'a%$',
            'alias#ï¿',
            'aa..',
            'aa--',
);

my $big_email
    = 'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq2saaa@clix.pt';

# format:  method_to_test => { 'args' => argumet_name, error_code => [ params to use] }
my %invalid_email_tests = (

    'verify_email' => { 'args' => 'email',
                        '702'  => \@spaces,
                        '703'  => \@invalid_emails,
                        '704'  => [$big_email],
    },
    'mail_aliases_verify' => {
        'args' => 'mail_aliases',
        '55'   => [
                  @spaces,
                  @invalid_emails,
                  [ 'xxx@aaa.pt',   'jcp@domain' ],
                  [ 'aaaa@httt.pt', @invalid_emails ],
                  [ 'aaaa@domain', 'xxx@aaa.pt', q{} ]
        ],
        '54' => [ [ q{}, 'xxx@aaa.pt' ], [ 'xxx@aaa.pt', q{} ] ],
        '56' => [ [ $big_email, 'email@clix.pt' ] ],

    },

    'verify_alias' => {
        'args' => 'mail_aliases',
        '1302' => [ @invalid_alias, [ 'jcp@sonae.com', @invalid_alias ] ],
        '1303' => [ 'xy890567', 'x4890567' ],    #business denies
        '1305' => [ # length(alias) > 30
            'qwertyuiopasdfghjklzxcvbnmqwerq',
            [  'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
               'email',
            ]
        ]
    },
);

for my $method ( keys %invalid_email_tests ) {
    my $args = $invalid_email_tests{$method}->{'args'};
    delete $invalid_email_tests{$method}->{'args'};

    for my $err_code ( keys %{ $invalid_email_tests{$method} } ) {
        for my $email ( @{ $invalid_email_tests{$method}->{$err_code} } ) {
            my $ret = $vrf->$method( 'ob' => 1, $args => $email );
            is( $ret, $err_code,
                $method . ' invalid email: ' . ( ref $email ? 'list' : $email ) );
        }
    }
}
exit;


