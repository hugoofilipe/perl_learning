#!/usr/bin/perl
use strict;
use warnings;
 
#To run this just console: plackup this_file.psgi
my $app = sub {
  return [
    '200',
    [ 'Content-Type' => 'text/html' ],
    [ 300 ],
  ];
};