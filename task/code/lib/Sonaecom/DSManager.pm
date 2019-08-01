package Sonaecom::DSManager;

use strict;
use warnings;

use Data::Dumper;
use Carp;

# Data Source Manager
# Facilitate getting list of records

#Instanciating this Class is not usefull, as does not know how to get records
#Try using a child class...
#
# Synopsis
#
# my $data_object = Sonaecom::DSManager->new( 
#                       'debug'      => ( $ENV{'DEBUG'} || 0 ),
#                        'filename'  => $filename, #optional)
# );
# 
# #set the input source
#
#    $data_object->set_input_source( $filename );
#
# # populate the data set
#
#    $data_object->prepare_records( );
#    $data_object->prepare_records( 'key_name' => 'username' );
#
# print "total objects : " . $data_object->total_records . "\n";
# 
# while ( my $user = $data_object->next_record ) {
#     my $username = $user->{'username'};
#     my $str = $data_object->count_one_more();
#     print $str if $str;
# }

sub new {
    my $c      = shift;
    my %params = @_;

    $params{'debug'} ||= 0;
    $params{'_records'}       = [];  # where the records will be kept
    $params{'_total_treated'} = 0;   # counter of how many records have been sent
    $params{'roll_over'}      = 10;  # used to control frequency of some debug messages
    $params{'_input_source'} ||= q{undefined};    # where records came from

    my $s = bless {%params}, $c;

    return $s;
}

sub total_records {
    return shift->{'total_records'};
}

sub total_treated {
    my $self = shift;
    return $self->{'_total_treated'};
}

sub set_input_source {
    my $self  = shift;
    my $input_source = shift;

    $self->{'_input_source'} = $input_source;
    return;
}

sub get_input_source {
    return shift->{'_input_source'};
}


# helper method to control how long a record took to
# be treated
sub count_one_more {
    my $self = shift;

    $self->{'_total_treated'}++;

    # set it, if initial time not set (only once!)
    $self->{'init_time'} ||= time;

    return q{}
        unless ( ( $self->{'_total_treated'} % $self->{'roll_over'} ) == 0 );

    my $p_time = time;
    my $spent  = $p_time - $self->{'init_time'};

    return sprintf( "treated %d of %d records in %d seconds (%s min)\n",
                    $self->{'_total_treated'},
                    $self->{'total_records'},
                    $spent, ( $spent / 60 ) );
}

sub next_record {
    my $self = shift;

    return unless scalar @{ $self->{'_records'} };
    return shift @{ $self->{'_records'} };
}

sub show_all {
    my $self = shift;

    return 'show_all: ' . Dumper( $self->{'_records'} );
}


sub prepare_records {
    my $self = shift;

    my $records = $self->get_records( @_ );

    if ( !scalar( @{$records} ) ) {
        $self->{'total_records'}  = 0;
        $self->{'_total_treated'} = 0;
        return $self->{'total_records'};
    }

    $self->{'_records'}       = $records;
    $self->{'total_records'}  = scalar( @{$records} );
    $self->{'_total_treated'} = 0;
    return $self->{'total_records'};
}

# method should load all records into array (array of hashes), and return ref to it
sub get_records {
    my $self = shift;
    croak 'get_records: Please override: ' . ref($self);
}

# nice user readable text, showing what type of input class treats
sub get_data_set_input_info {
    return 'INPUT_TYPE: undefined';
}

sub debug {
    return unless shift->{'debug'};
    print STDERR "@_\n";
    return;
}

1;
