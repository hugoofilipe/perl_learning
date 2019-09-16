#!/usr/bin/perl
use lib '/home/hugo/projects/nos/perl_learning/Post_multi_groups_facebook';
use Try::Tiny;
use Data::Dumper;
use HTTP::Cookies;
use YAML::XS 'LoadFile';
use Lib::Manager;
use Lib::FileLogger;
use Lib::ReadFile;
use WWW::Mechanize;

# turn on perl's safety features
use strict;
use warnings;
# use feature qw(say);


my $config = LoadFile( 'Lib/config.yaml' );
if ( Lib::Manager::DEBUG ) {
#     print Dumper( $config );
#    print "\nRead from file: ", Lib::Manager::READ_FROM_FILE;
}

Lib::FileLogger::openLogger($config->{log_file_path});
Lib::FileLogger::log(1, 'Starting');

my $url_path;

if ( Lib::Manager::READ_FROM_FILE ) {
    my $file_name = $ARGV[0]
        or die
        "\nERROR - You must specify a file name on command line, where are all facebook groups url's:\nEx:facebook_groups.txt";
    my @data = get_urls( $file_name );
}
elsif ( Lib::Manager::READ_FROM_YAML ) {
    my $file_name = $ARGV[0]
        or die
        "\nERROR - You must specify a file name on command line, where are all facebook groups url's:\nEx:facebook_groups.txt";
    my @data = get_urls( $file_name );content();
}
else {
    my $url_path = $ARGV[0]
        or die
        "\nERROR - You must specify one url of facebook group on command line.\nEx: https://www.facebook.com/groups/231075801024969/";
}

my $mech = WWW::Mechanize->new(autocheck => 1, strict_forms => 1);
$mech->cookie_jar(HTTP::Cookies->new());
$mech->get( "https://github.com/" );


#$mech->follow_link( text_regex => qr/CPAN/i );
#$mech->follow_link( text_regex => qr/Waiter/i );

# $mech->submit_form(
#     form_number => 3,
#     fields      => {
#         username    => 'mungo',
#         password    => 'lost-and-alone',
#     }
# );

#print "\n current fields ", Dumper my @fields = $mech->find_al(), "\n";
print "\n All forms: ", Dumper my @all_forms = $mech->forms,"\n";

my $content_last_url = $mech ->content();
my $last_url = $mech -> uri();
my @list_links = $mech->links();

exit;
try {
    system( 'google-chrome', $last_url );
}
catch {
    warn "\ncaught error: $_";
};

exit;
# # create a new mechanize
# #link: https://metacpan.org/pod/WWW::Mechanize 
# my $mech = WWW::Mechanize->new();
# $mech->cookie_jar(HTTP::Cookies->new());
# $mech->get( $config->{url_facebook} );
# $mech->form_name('menubar_login');
# $mech->field(email => $config->{credencials}->{username});
# $mech->field(pass => $config->{credencials}->{password});
# $mech->click();
# my $facebook_content = $mech->content();

# # go to an app url
# if ( Lib::Manager::READ_FROM_FILE ) {
#     Lib::FileLogger::log(1, 'read from file not completely implemented');
#     exit;
# }
# else {
#     print "\nhere: $url_path";
#     $mech->get( $url_path );
#     my $app_content = $mech->content();

#     #print "$app_content\n";
# }



# try {
#     system( 'google-chrome', $url_path );
# }
# catch {
#     warn "\ncaught error: $_";
# };


# # my @forms = $mech->forms;
# my @forms = $mech->form_name('menubar_login');
# print Dumper @forms;
# exit;

# # click on the link that matches the module name
# # $mech->follow_link( text_regex => $module_name );

# my $status= $mech->success();
# my $url = $mech->uri();
# print "status: $status";
# # launch a mech...

# my $status1= $mech->success();
# print "status: $status1";

# exit( 0 );
