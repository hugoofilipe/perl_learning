#!/usr/bin/perl
#run:
#perl anylise_arguments.pl 1 2 1 23 345 hello one 34 3 456 90011uu 23 lanana 

use strict;
use warnings;
use Data::Dumper qw(Dumper);
use 5.014;

my $total_arg = $#ARGV + 1;
print ("Total arguments:" . $total_arg . "\n");

my @even;
my @odd;
my @other; 
my @banana_candidate;


foreach my $arg(@ARGV){

	if ($arg == m/[a-zA-Z]/){
		if ($arg == m/[0-9]/){
	 		print "The string contains non-alphanumeric characters \n";
	 		push @other, $arg
		}
 		print "The string contains only alphanumeric characters \n";
		push @banana_candidate, $arg;
		next;
	}

    if(0 == $arg % 2){
        print "$arg is even\n";
        push @even, $arg;
        print ref $arg;
    }
    else{
        print "$arg is odd\n";
        push @odd, $arg;
    }
}
    
print "Own message: END!\n";    
say Dumper \@even;
say Dumper \@odd;
say Dumper \@banana_candidate;