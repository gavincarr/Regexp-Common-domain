# Test hostname extraction

use utf8;
use strict;
use warnings;
use warnings  qw(FATAL utf8);
use open      qw(:std :utf8);
use Test::More;
use Test::Deep;
use List::MoreUtils qw(natatime);
use Net::IDN::Encode ':all';
use Regexp::Common qw(domain);

my @tests_ascii = (
  'www.google.com'                  => 'www.google.com',
  'www.flickr.net'                  => 'www.flickr.net',
  'www.amazon.co.uk'                => 'www.amazon.co.uk',
  'www.openfusion.com.au.'          => 'www.openfusion.com.au.',
  'duckduckgo.com, of course'       => 'duckduckgo.com',
  'RT openclipart.org <-- try this' => 'openclipart.org',
  'bit.ly, ur1.ca, and TINYURL.ORG are all url shorteners'
                                    => [qw(bit.ly ur1.ca TINYURL.ORG)],
  'http://www.example.com:8080/abc/index.html#fragment?foo=1&bar=2'
                                    => 'www.example.com',
  '24x7.medguru.info'               => '24x7.medguru.info',
  'www.example.kp'                  => 'www.example.kp',
  'www.example.pm'                  => 'www.example.pm',
  'www.example.so'                  => 'www.example.so',
  'www.example.tel'                 => 'www.example.tel',
  'www.example.wf'                  => 'www.example.wf',
  'www.example.xxx'                 => 'www.example.xxx',
  'www.example.yt'                  => 'www.example.yt',
  'one.com.co.xxx'                  => 'one.com.co.xxx',
);
my @tests_utf8 = (
  'xyz.рф'                          => 'xyz.xn--p1ai',
  'xyz.рус'                         => 'xyz.xn--p1acf',
  'правительство.рф'                => 'xn--80aealotwbjpid2k.xn--p1ai',
  'правительство.рус'               => 'xn--80aealotwbjpid2k.xn--p1acf',
  'ουτοπία.δπθ.gr'                  => 'xn--kxae4bafwg.xn--pxaix.gr',
  '互联网中心.中国'                 => 'xn--fiq7iq58bfy3a8bb.xn--fiqs8s',
);

# Ascii tests
my $it = natatime 2, @tests_ascii;
while (my ($text, $expected) = $it->()) {
  my @got = $text =~ m/$RE{domain}{hostname}{-keep}/og;
  if (ref $expected) {
    cmp_deeply \@got, $expected, "$text ok";
  }
  else {
    is($got[0], $expected, "$text ok");
  }
}

# UTF8 tests
$it = natatime 2, @tests_utf8;
while (my ($utf8, $expected) = $it->()) {
  my $text = domain_to_ascii( $utf8 );
  my @got = $text =~ m/$RE{domain}{hostname}{-keep}/og;
  if (ref $expected) {
    cmp_deeply \@got, $expected, "$text ok";
  }
  else {
    is($got[0], $expected, "$text ok");
  }
}

done_testing;

