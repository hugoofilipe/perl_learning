package Sonaecom::DSManager::File::Simple;

use base qw( Sonaecom::DSManager::File );

use strict;
use warnings;
use feature qw(say);

use lib '/servers/libs/novis';
use Sonaecom::Logger qw(get_logger);
use Data::Dumper;
use Carp;

my $l = get_logger();

my $filename = '~/perl_learning/files/trash_text_old.txt'

my $data_object = Sonaecom::DSManager->new(
    'debug' => ( $ENV{'DEBUG'} || 0 ),
    'filename' => $filename,    #optional)
);

#set the input source

$data_object->set_input_source( $filename );

# populate the data set

$data_object->prepare_records();
$data_object->prepare_records( 'key_name' => 'username' );

print "total objects : " . $data_object->total_records . "\n";

while ( my $user = $data_object->next_record ) {
    my $username = $user->{'username'};
    my $str      = $data_object->count_one_more();
    print $str if $str;
}
