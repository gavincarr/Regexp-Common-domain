#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Regexp::Common::domain' ) || print "Bail out!
";
}

diag( "Testing Regexp::Common::domain $Regexp::Common::domain::VERSION, Perl $], $^X" );
