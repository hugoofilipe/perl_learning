#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Data::Dumper;
use lib './';

use Apache::Log::Parser;
use Visitors;

my @blacklist_for_request = (
    "/[a-f0-9]+/css/", "/[a-f0-9]+/images/",
    "/[a-f0-9]+/js/",  "/entry-images/",
    "/images/",        "/user-images/",
    "/static/",        "/robots.txt",
    "/favicon.ico",
);

my @blacklist_for_path = ( ".rss", ".atom", );

my $file = "../access.medium.log";
#my$file = "../access_shorted.log";

#if(!$file ){
#    print"Please write the file name by argument , like \"../access.log\"";
#}else{
#    print $file;
#}

my $visitor = Visitors->new();

open my $in,  '<', $file;
open my $out, '>', "$file.stripped";
my $parser = Apache::Log::Parser->new( fast => 1 );



print "\n";

NEXT: while ( <$in> ) {
    my $record = $parser->parse( $_ );

    # MFA was hot-linking this image from their blog
    for my $rule_request_str ( @blacklist_for_request ) {
        if (   $record->{request}
            && $record->{request} =~ m{\Q$rule_request_str} ) {
            next NEXT;
        }
    }

    for my $rule_path_str ( @blacklist_for_path ) {
        if ( $record->{path} && $record->{path} =~ m{\Q$rule_path_str} ) {
            next NEXT;
        }
    }

    if (not exists $record->{path}){
        next NEXT;
    }

    $record->{referer} = q{ - };
    
    # There are some weird entries in the vegguide.org logs, apparently.
    next unless $record->{datetime};
    my $ip_address = $record->{rhost};
    my $path = $record->{path};
    $visitor->get_city( $ip_address );
    $visitor->get_country( $ip_address, $path);
    
    # print into file stripped
    print {$out} join q{ }, @{$record}{qw( rhost logname user )},
        _bracket( $record->{datetime} ),
        _quote( $record->{request} ), @{$record}{qw( status bytes )},
        _quote( $record->{referer} ),
        _quote( $record->{agent} );
    print {$out} "\n";
}

close $out;


#print list of cities
#print $visitor->cities_list(), "\n";

#print list of countries
#print $visitor->countries_list();

sub _bracket {
    return '[' . $_[0] . ']';
}

sub _quote {
    return q{"} . $_[0] . q{"};
}


sub get_html {
    return q{
        <form>
  
        <input name="field">
        <input type="submit" value="Echo">
        </form>
        <hr>
    }
}

#To run this just console: plackup
use Plack::Request;

my $app = sub {

    my $env = shift;
    my $html = get_html();
    my $file = "../access_shorted.log";

    my $request = Plack::Request->new($env);
 
    # if ($request->param('field')) {
    #     $html .= 'You said: ' . $request->param('field');
    #     $file = $request->param('field');
    # }
    return [
        '200',
        [ 'Content-Type' => 'text/html' ],
        [ $visitor->cities_list(), $visitor->countries_list(), $html, Dumper \$env ],
    ];
};
