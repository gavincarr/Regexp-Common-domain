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
  '24x7.medguru.info'               => [qw(24x7.medguru.info)],
  'www.example.bl'                  => [qw(www.example.bl)],
  'www.example.bv'                  => [qw(www.example.bv)],
  'www.example.eh'                  => [qw(www.example.eh)],
  'www.example.gb'                  => [qw(www.example.gb)],
  'www.example.kp'                  => [qw(www.example.kp)],
  'www.example.mf'                  => [qw(www.example.mf)],
  'www.example.pm'                  => [qw(www.example.pm)],
  'www.example.sj'                  => [qw(www.example.sj)],
  'www.example.so'                  => [qw(www.example.so)],
  'www.example.tel'                 => [qw(www.example.tel)],
  'www.example.tp'                  => [qw(www.example.tp)],
  'www.example.um'                  => [qw(www.example.um)],
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

