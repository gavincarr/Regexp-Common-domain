#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Regexp::Common::hostname' ) || print "Bail out!
";
}

diag( "Testing Regexp::Common::hostname $Regexp::Common::hostname::VERSION, Perl $], $^X" );
