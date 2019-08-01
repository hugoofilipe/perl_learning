#package Sonaecom::DSManager::File::Simple;

use strict;
use warnings;

use lib './task/code/lib';

#use Sonaecom::DSManager::File::CSV;
use Sonaecom::DSManager::File::Simple;

#use Sonaecom::Logger qw(get_logger);
use Data::Dumper;
use Carp;

#my $l = get_logger();

my $filename = '/servers/data/8/h/hvduarte/perl_learning/files/trash_text_old.txt';
my $data_object = Sonaecom::DSManager::File::Simple->new(
    'debug' => ( $ENV{'DEBUG'} || 0 ),
    'filename' => $filename,headers => "auto",    #optional)
);

#set the input source

$data_object->set_input_source( $filename );

# populate the data set

$data_object->prepare_records();
$data_object->prepare_records( 'key_name' => 'username' );
my $records = $data_object->get_records();

print "total objects : " . $data_object->total_records . "\n";
print Dumper($records);

while ( my $user = $data_object->next_record ) {
    my $username = $user->{'username'};
    my $str      = $data_object->count_one_more();
    print $str if $str;
}
