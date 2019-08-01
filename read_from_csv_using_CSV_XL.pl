# Object interface
use strict;
use warnings;
use Data::Dumper;

# Functional interface
use Text::CSV_XS;

my $filename = '/servers/data/8/h/hvduarte/perl_learning/csv_file.csv';
#my $filename = '/servers/data/8/h/hvduarte/perl_learning/delegates.csv';

my @rows;
# Read/parse CSV
my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
open my $fh, "<:encoding(utf8)", $filename or die "test.csv: $!";
while (my $row = $csv->getline ($fh)) {
    push @rows, $row;
    }
print "***** Start *****\n";
print Dumper(@rows);
print "***** Fim *****\n";
close $fh;
