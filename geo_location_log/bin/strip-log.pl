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

my $file = shift;
open my $in,  '<', $file;
open my $out, '>', "$file.stripped";
my $parser = Apache::Log::Parser->new( fast => 1 );

my $visitor = Visitors->new();
print Dumper($visitor);

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
    $record->{referer} = q{ - };

    # There are some weird entries in the vegguide.org logs, apparently.
    next unless $record->{datetime};
    my $ip_address = $record->{rhost};
    print 'City: '
        . $visitor->get_city( $ip_address )
        . '  --- Country: '
        . $visitor->get_country( $ip_address )
        . "  --  ip: "
        . $ip_address . "\n";

    print {$out} join q{ }, @{$record}{qw( rhost logname user )},
        _bracket( $record->{datetime} ),
        _quote( $record->{request} ), @{$record}{qw( status bytes )},
        _quote( $record->{referer} ),
        _quote( $record->{agent} );
    print {$out} "\n";
}

close $out;

sub _bracket {
    return '[' . $_[0] . ']';
}

sub _quote {
    return q{"} . $_[0] . q{"};
}
