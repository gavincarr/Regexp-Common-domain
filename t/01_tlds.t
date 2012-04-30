# Test tld extraction

use strict;
use Test::More;
use Test::Deep;
use Data::Dump qw(pp);
use List::MoreUtils qw(natatime);

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Regexp::Common qw(domain);

my @tests = (
  'www.google.com'                  => [qw(com)],
  'www.flickr.net'                  => [qw(net)],
  'www.amazon.co.uk'                => [qw(uk)],
  'www.openfusion.com.au'           => [qw(au)],
  'duckduckgo.com, of course'       => [qw(com)],
  'openclipart.org <-- try this'    => [qw(org)],
  'bit.ly, ur1.ca, and TINYURL.ORG are all url shorteners'
                                    => [qw(ly ca ORG)],
  'xn--node, xn--3e0b707e, and xn--ygbi2ammx are IDN TLDs'
                                    => [qw(xn--node xn--3e0b707e xn--ygbi2ammx)],
);

my $it = natatime 2, @tests;
while (my ($text, $expected) = $it->()) {
  my @got = $text =~ m/$RE{domain}{tld}{-keep}/og;
  cmp_deeply \@got, $expected, "$text ok";
}

done_testing;

