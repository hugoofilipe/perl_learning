#!usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use feature qw(say);

my $file_name = $ARGV[0];

welcome();

my @data = read_file();
print_array(@data);

sub welcome {
    if ( not defined $file_name ) {
        die "Need name of file \n";
    }
    say('welcome ');
    return;
}

sub read_file {
    open my $handle, '<', $file_name;
    chomp( my @lines = <$handle> );
    close $handle;
    return @lines;
}

sub print_array {
    foreach (@_) {
        say($_ );
    }
}

sub terminate {
    die "Hasta La Vista";
}
