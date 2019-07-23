#!/usr/bin/perl
use strict;
use warnings;

use Path::Tiny;


my $dir = path('~/projects/nos/perl_learning');

#iterate over the content of dir path 
my $iter = $dir->iterator;
while (my $file = $iter->()){
    next if $file->is_dir();
        
    print"$file\n";
}

print($dir);
