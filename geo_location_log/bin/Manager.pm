package Manager;

use strict;
use warnings;

my $blacklist_for_request = (
    "/[a-f0-9]+/css/", "/[a-f0-9]+/images/",
    "/[a-f0-9]+/js/",  "/entry-images/",
    "/images/",        "/user-images/",
    "/static/",        "/robots.txt",
    "/favicon.ico",
);

my @blacklist_for_path = ( ".rss", ".atom", );

1;
