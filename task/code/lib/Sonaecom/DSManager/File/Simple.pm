package Sonaecom::DSManager::File::Simple;

use base qw( Sonaecom::DSManager::File );

use strict;
use warnings;

use Data::Dumper;
use Carp;

# IN: key_name the keyname tag OPTIONAL default='username'
# IN: fd       file descriptor MANDATORY
# RET: an array of hash_refs, indexed by key_name
# ex:
#   [
#       { 'username' => 'jcp' }
#       { 'username  => 'root'}
#       { 'username  => 'xpto'}
#   ]

sub _process_records {
    my $self  = shift;
    my $fd_in = shift;
    my %args  = @_;
    my @recs;
    chomp( my @lines = <$fd_in> );
    foreach ( @lines ) {
        push @recs, { 'username' => $_ };
    }
    return \@recs;
}

sub get_data_set_input_info {
    my $self = shift;

    return 'INPUT_TYPE: File::Simple';
}

my $var = Sonaecom::DSManager->new( '', '' );

1;
