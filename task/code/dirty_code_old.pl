#!/usr/bin/perl


use Data::Dumper;

&perlcritic_stuff( "first_param" );

sub perlcritic_stuff {

    return unless !$ENV{'DEBUG'};

if ( $_[0] eq 'umdoistres' ) {
		print "WOW, um dois tres!";
        die "Good bye cruel world!\n";
	}

my $str = '';

    for (my $i = 0; $i < 10; $i++) {
print "$i\n";
    }

    my $reg_exO = '2010:12';
    if ( $reg_ex0 =~ /(\d+):(\d+)/ ) {
        print "year: $1, month: $2\n";
    }else{
    print "unexpected error\n";
    }
}


sub open {
print "Lets open a file!\n";
    my $file = "/tmp/no_such_file.txt";
    my $IN;
    open( $IN, $file );


}

