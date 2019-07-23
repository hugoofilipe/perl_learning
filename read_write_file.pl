#!/usr/bin/perl


use strict;
use warnings;

use Path::Tiny;
use autodie; #die if problem reading or writing a file

# Step 1: writing a file
my $dir = path('~/projects/nos/perl_learning/files');
my $file = $dir -> child('trash_text1.txt');

my $file_handle = $file-> openw_utf8();

my @list = ('This','list','is a','test');

foreach my $line (@list){
    $file_handle->print($line . "\n");
}

#Step 2: Reading a file

my $file_to_read = $dir->child("trash_text_old.txt");

my $read = $file_to_read->slurp_utf8();
my $content = $file_to_read-> openr_utf8();

print "Debug message: Try start reading\n";
while (my $line = $content->getline()){
    print $line;
}

print "Debug message: End!\n";



#appending to a file
#my $file_handle_to_read = $file-> opena_utf8();
