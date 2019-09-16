#!usr/bin/perl
package Lib::ReadFile;

sub get_urls {
    my $file_name = shift;
    if ( not defined $file_name ) {
        die "Need name of file \n";
    }

    return read_file($file_name);
}

sub read_file {
    my $file_name = shift;
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
1;