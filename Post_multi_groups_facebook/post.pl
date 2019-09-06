#!/usr/bin/perl
use Try::Tiny;
use Data::Dumper;
use HTTP::Cookies;
use FileLogger;
use Read_file;

# turn on perl's safety features
use strict;
use warnings;
use feature qw(say);

#CONSTANTS
my $url_facebook = "http://www.facebook.com";
my $read_from_file = False
my $username = '****';
my $password = '****';

# create a new mechanize
#link: https://metacpan.org/pod/WWW::Mechanize 
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();

if ( $read_from_file ) {
    my $file_name = $ARGV[0];
            or die "Must specify file name on command line, where are all facebook groups url's:\nex:facebook_groups.txt";
    my @data = get_urls( $file_name );
} else {
    my $url_path = $ARGV[0]
        or die "Must specify the facbook group url on command line\nex:https://www.facebook.com/^Coups/231075801024969/";
}
exit;

$mech->cookie_jar(HTTP::Cookies->new());
$mech->get( $url_facebook );
$mech->form_name('menubar_login');
$mech->field(email => $username);
$mech->field(pass => $password);
$mech->click();
my $facebook_content = $mech->content();
# go to an app url
$mech->get($url_path);
my $app_content = $mech->content();
#print "$app_content\n";

try {
    system( 'google-chrome', $url_path );
}
catch {
    warn "\ncaught error: $_";
};


# my @forms = $mech->forms;
my @forms = $mech->form_name('menubar_login');
print Dumper @forms;
exit;

# click on the link that matches the module name
# $mech->follow_link( text_regex => $module_name );

my $status= $mech->success();
my $url = $mech->uri();
print "status: $status";
# launch a mech...

my $status1= $mech->success();
print "status: $status1";

try {
    system( 'google-chrome', $url );
}
catch {
    warn "\ncaught error: $_";
};

exit( 0 );
