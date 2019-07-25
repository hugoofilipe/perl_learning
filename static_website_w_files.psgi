#!/usr/bin/perl
use strict;
use warnings;

# Serve static files from document root with a directory index
# static_website.psgi
#To run this just console: plackup this_file.psgi

use Plack::App::Directory;
my $app = Plack::App::Directory->new({ 
                root => "/home/hugo/projects/nos/perl_learning/files" 
            })->to_app;
