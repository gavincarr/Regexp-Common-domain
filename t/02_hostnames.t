# Test hostname extraction

use strict;
use Test::More;
use Test::Deep;
use Data::Dump qw(pp);
use List::MoreUtils qw(natatime);
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
  'http://www.example.com:8080/abc/index.html#fragment?foo=1&bar=2'
                                    => [qw(www.example.com)],
  '24x7.medguru.info'               => [qw(24x7.medguru.info)],
  'www.example.kp'                  => [qw(www.example.kp)],
  'www.example.pm'                  => [qw(www.example.pm)],
  'www.example.so'                  => [qw(www.example.so)],
  'www.example.tel'                 => [qw(www.example.tel)],
  'www.example.wf'                  => [qw(www.example.wf)],
  'www.example.xxx'                 => [qw(www.example.xxx)],
  'www.example.yt'                  => [qw(www.example.yt)],
);

my $it = natatime 2, @tests;
while (my ($text, $expected) = $it->()) {
  my @got = $text =~ m/$RE{domain}{hostname}{-keep}/og;
  cmp_deeply \@got, $expected, "$text ok";
}

done_testing;

