package Sonaecom::DSManager::File;

use base qw( Sonaecom::DSManager );

use strict;
use warnings;

use Data::Dumper;
use Carp;


sub set_input_file {
    my $self = shift;
    return $self->set_input_source( @_ );
}

# return a array of hash_data
sub _process_records {
    croak 'Please overide this method _process_records';
}

sub get_records {
    my $self = shift;
    my %args = @_;

    my $filename = $self->get_input_source();
    if ( !$filename ) {
        croak 'input filename not set. use set_input_source()';
    }

    if ( !-f $filename ) {
        croak "NOT a file: $filename\n";
    }

    my $fd_in;
    if ( !open( $fd_in, '<', $filename ) ) {
        croak "unable to open $filename for reading: $!\n";
    }

    my $record_arr =  $self->_process_records( $fd_in, %args );

    close( $fd_in ) || print STDERR "WARN: unable to close fd_in\n";

    return $record_arr;
}

sub get_data_set_input_info {
    my $self = shift;

    return 'INPUT_TYPE: File::Simple';
}

1;
