#!/usr/bin/perl
use lib '/home/hugo/projects/nos/perl_learning/Post_multi_groups_facebook';
use Try::Tiny;
use Data::Dumper;
use HTTP::Cookies;
use YAML::XS 'LoadFile';
use Lib::Manager;
use Lib::FileLogger;
use Lib::ReadFile;
# use WWW::Selenium;
use Selenium::Remote::Driver;
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

my $driver = Selenium::Remote::Driver->new(
    'remote_server_addr' => '127.0.0.1',
    'port'               => '4444',
    'browser_name'       => 'chrome',
    'extra_capabilities' =>
        { 'chromeOptions' => { 'args' => [ 'notifications=dis' ] } },
    'headless'   => 0,
    'auto_close' => 0
);

$driver->debug_on;



# $driver->general_action(
#     actions => [
#         {   type    => 'key',
#             actions => [
#                 {   type => "KeyDown",
#                     key  => 'A',
#                 },
#             ]
#         },
#     ]
# );

$driver->get($config->{url_facebook});
print "\n Opened ", $driver->get_title();

my $login = $driver->find_element_by_id('email');
$login -> send_keys($config->{credencials}->{username});
print "\nEmail Id entered...\n";

my $password = $driver->find_element_by_id('pass');
$password->send_keys($config->{credencials}->{password});
print "\nPassword Id entered...\n";

my $log_in = $driver->find_element_by_id('loginbutton');
$log_in -> click;
print "\nLogin submited...\n";
sleep(3);

print "\nPlace here the Code genneration from your smartphone:\n";
my $keyboard = <STDIN>;
my $twofa = $driver->find_element_by_id('approvals_code');
$twofa -> send_keys($keyboard);
print "\nCode genneration submited...\n";
sleep(3);

for ( 1 .. 4 ) {
    if ( my $var = $driver->find_element_by_id( 'checkpointSubmitButton' ) ) {
        $var->click;
        sleep( 3 );
    }
}

sleep(10);
$driver->get('https://www.facebook.com/groups/231075801024969/');
print $driver->get_title();

sleep(10);

my $post_box=$driver->find_element_by_xpath("//*[\@name='xhpc_message_text']");
#find_element("//input[\@name='q']");
#my $post_box2=$driver->find_element_by_xpath("//*[\@name='xhpc_message_text']");
#my $post_box3=$driver->find_elements("//input");


$post_box->send_keys("Sou o maior");
sleep(2);
print "writed";
my $post_it=$driver->find_element_by_xpath("//*[\@id='u_0_1u']/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[2]/button[\@type='submit']")->click('LEFT');
sleep(15);
print "Posted...";
$driver->quit();