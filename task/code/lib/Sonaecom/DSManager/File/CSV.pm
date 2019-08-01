package Sonaecom::DSManager::File::CSV;

use base qw( Sonaecom::DSManager::File );

#  IN: strip_empty:     strip empty lines from data array
#  IN: col_names:       array of colnames
#
#
# note if col_names_from_file colnames will be:
#       lowercased
#       spaces substituted for "_" (underscore)
#

use strict;
use warnings;

use Data::Dumper;
use Carp;

use Text::CSV_XS;

sub new {
    my $c      = shift;
    my %params = @_;

    my $self = $c->SUPER::new( %params );

    # TODO: allow flag: cols_from_first_line
    if ( $params{'col_names'} ) {
        $self->set_colnames( $params{'col_names'} );
    }

    return $self;
}

# receive as array_ref or plain array
sub set_colnames {
    my $self = shift;

    #if ( ref( $params{'col_names'} ) eq 'ARRAY' ) )

    my @cols = (
        ref( $_[0] ) eq 'ARRAY'
        ? @{ $_[0] }
        : @_
    );

    $self->{'col_names'} = \@cols;

    return;
}

# IN:  string(s)
# verify if string(s) exist in @self->col_names
#
# RET:  1:  exists
#       0:  one or more missing
#
sub exists_mandatory_cols {
    my $self = shift;

    if ( !$self->{'col_names'} ) {
        $self->debug(
            sprintf( "%s %s: %s\n",
                'CSV.pm', 'exists_col_name', 'col_names not set' )
        );
        return 0;
    }

    my @check_these = @_;

    for my $val ( @check_these ) {
        return 0 unless grep( /^$val$/, @{ $self->{'col_names'} } );
    }

    return 1;
}

# IN: fd       file descriptor MANDATORY
# RET: an array of hash_refs,  each hash containing a line from the CSV file
#   [
#       { 'key1' => 'val1', 'key2' => 'val2', ... }
#       { 'key1' => 'val1', 'key2' => 'val2', ... }
#       ...
#   ]

# sub _process_records {
#     my $self  = shift;
#     my $fd_in = shift;
#     my %args  = @_;
#     my @recs_column;
#     my @recs;
#     # code here

#     while ( my $line = <$fd_in> ) {
#         chomp $line;
#         my @fields = split ",", $line;
#         my $colunm = 1;
#         foreach(@fields){

#             push @recs_column, { 'key' . $colunm => $_ };
#             $colunm++;
#         }
#         push @recs, @recs_column;
#         @recs_column = ();
#     }

#     return \@recs;
# }

sub _process_records {
    my $self  = shift;
    my $fd_in = shift;
    my %args  = @_;
    my @recs_column;
    my @recs;

    # Read/parse CSV
    my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
    $csv->header ($fd_in, { set_column_names => 2 });
    while (my $row = $csv->getline($fd_in)) {
        push @recs, $row;
        }

    return \@recs;
}

sub get_data_set_input_info {
    my $self = shift;

    return 'INPUT_TYPE: File::CVS';
}

1;
