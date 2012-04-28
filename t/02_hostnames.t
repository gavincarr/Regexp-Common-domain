# Test hostname extraction

use strict;
use Test::More;
use Test::Deep;
use Data::Dump qw(pp);
use List::MoreUtils qw(natatime);

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Regexp::Common qw(domain);

my @tests = (
  'www.google.com'                  => [qw(www.google.com)],
  'www.flickr.net'                  => [qw(www.flickr.net)],
  'www.amazon.co.uk'                => [qw(www.amazon.co.uk)],
  'www.openfusion.com.au'           => [qw(www.openfusion.com.au)],
  'duckduckgo.com, of course'       => [qw(duckduckgo.com)],
  'RT openclipart.org <-- try this' => [qw(openclipart.org)],
  'bit.ly, ur1.ca, and TINYURL.ORG are all url shorteners'
                                    => [qw(bit.ly ur1.ca TINYURL.ORG)],
  'http://www.example.com:8080/abc/index.html'
                                    => [qw(www.example.com)],
);

my $it = natatime 2, @tests;
while (my ($text, $expected) = $it->()) {
  my @got = $text =~ m/$RE{domain}{hostname}{-keep}/og;
  cmp_deeply \@got, $expected, "$text ok";
}

done_testing;

