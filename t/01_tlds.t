# Test tld extraction

use strict;
use Test::More;
use Test::Deep;
use Data::Dump qw(pp);
use List::MoreUtils qw(natatime);
use Regexp::Common qw(domain);

my @bare_tests = (
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
  'new TLDs: domains google glass iinet'
                                    => [qw(new domains google glass iinet)],
  'NDT, absent from Mozilla PSL: koeln, um'
                                    => [qw(koeln um)],
);

my @todo_tests = (
  # http://data.iana.org/TLD/tlds-alpha-by-domain.txt
  'IANA list,  absent from NDT and MPSL: bmw, care, ooo, surf'
                                    => [qw(bmw care ooo surf)],
);

my @anchored_tests = (
  'bit.ly, ur1.ca, and TINYURL.ORG are all url shorteners'
                                    => [qw(ly ca ORG)],
  'new TLDs, bare: domains google glass iinet'
                                    => [],
  'new TLDs, dotted: .domains .google .glass .iinet'
                                    => [qw(domains google glass iinet)],
  'new TLDs, hostnames: www.in.domains search.google x-ray.glass internode.iinet'
                                    => [qw(domains google glass iinet)],
);

my $it = natatime 2, @bare_tests;
while (my ($text, $expected) = $it->()) {
  my @got = $text =~ m/$RE{domain}{tld}{-keep}/og;
  cmp_deeply \@got, $expected, "$text ok"
    or pp \@got;
}

my $it = natatime 2, @anchored_tests;
while (my ($text, $expected) = $it->()) {
  my @got = $text =~ m/ (?<=\.) $RE{domain}{tld}{-keep}/ogx;
  cmp_deeply \@got, $expected, "$text ok"
    or pp \@got;
}

done_testing;

