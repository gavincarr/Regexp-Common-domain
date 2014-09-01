package Regexp::Common::domain;

use warnings;
use strict;
use Regexp::Common qw(pattern);
use Net::Domain::TLD 1.72 ();
use Domain::PublicSuffix 0.09;
use Net::LibIDN qw(idn_to_ascii);
use List::MoreUtils qw(uniq);

my $HOSTNAME_CHARS = "a-zA-Z0-9-";
my $HOSTNAME_CHARS_CLASS = "[$HOSTNAME_CHARS]";
my $HOSTNAME_CHARS_DOT_CLASS = "[.$HOSTNAME_CHARS]";
my $HOSTNAME_CHARS_UNDERSCORE_CLASS = "[_$HOSTNAME_CHARS]";
my $HOSTNAME_CHARS_UNDERSCORE_DOT_CLASS = "[_.$HOSTNAME_CHARS]";

my $NON_HOSTNAME_CHARS_CLASS = "[^$HOSTNAME_CHARS]";
my $NON_HOSTNAME_CHARS_DOT_CLASS = "[^.$HOSTNAME_CHARS]";
my $NON_HOSTNAME_CHARS_UNDERSCORE_CLASS = "[^_$HOSTNAME_CHARS]";
my $NON_HOSTNAME_CHARS_UNDERSCORE_DOT_CLASS = "[^_.$HOSTNAME_CHARS]";

 
# TLDs via Domain::PublicSuffix
my $dps = Domain::PublicSuffix->new;
my %tld = map { $_ => [] } qw(2 3 4);

for (sort map { idn_to_ascii($_, "utf-8") } keys %{$dps->tld_tree}) {
  # Categorise TLDs by length
  my $len = length $_;
  $len = 4 if $len > 4;
  push @{$tld{$len}}, $_;
}

my $TLDs = join '|', uniq(Net::Domain::TLD::tlds(), @{$tld{3}}, @{$tld{4}}, @{$tld{2}});


# -------------------------------------------------------------------------
# Pattern definitions

pattern
  name   => [ qw(domain tld) ],
  create => # work break, open capture
            "(?i)\\b(?k:" .
            # TLD alternation
            $TLDs .
            # close capture
            ")" .
            # and must be followed by a non-domain character (or end-of-string)
            "(?:(?=$NON_HOSTNAME_CHARS_UNDERSCORE_DOT_CLASS)|\$)"
  ;

pattern
  name   => [ qw(domain hostname) ],
  create => # word break, open capture
            "(?i)\\b(?k:" .
            # each subdomain element is a set of hostname characters, up to 64, followed by a dot
            "(?:${HOSTNAME_CHARS_UNDERSCORE_CLASS}{1,64}\\.)+" .
            # domains must terminate with a TLD
            "(?:$TLDs)" .
            # close capture
            ")" .
            # and must be followed by a non-domain character (or end-of-string)
            "(?:(?=$NON_HOSTNAME_CHARS_UNDERSCORE_DOT_CLASS)|\$)"
  ;


1;

__END__

=head1 NAME

Regexp::Common::domain - Patterns for matching DNS domains and TLDs

=head1 SYNOPSIS

    use Regexp::Common qw(domain);

    @tlds      = $text =~ m/$RE{domain}{tld}{-keep}/og;
    @hostnames = $text =~ m/$RE{domain}{hostname}{-keep}/og;

=head1 DESCRIPTION

Please see L<Regexp::Common> for a general description of the $RE
inteface. You do not load it directly, but via Regexp::Common, as in the
C<use> statement in the SYNOPSIS.

This module provides regular expressions for matching and capturing
domains/hostnames and top-level-domains (TLDs) used by the Domain
Name System.

=over 4

=item $RE{domain}{tld}

Returns a pattern that matches any TLD defined in L<Net::Domain::TLD> or
L<Domain::PublicSuffix> (since neither seem exhaustive alone).

To capture the TLDs matched, use the standard Regexp::Common {-keep} option
e.g.

    @tlds = $text =~ m/$RE{domain}{tld}{-keep}/og;

This pattern begins and ends with a \b word-break pattern, and is
case-insensitive. 

If you don't want to match standalone TLDs (which now include many ordinary
words e.g. agency associates autos beer best bike etc.) you should anchor
the pattern e.g. with a dot in a zero-length lookbehind assertion i.e.

    @tlds = $text =~ m/ (?<=\.) $RE{domain}{tld}{-keep}/ogx;

=item $RE{domain}{hostname}

Returns a pattern that matches a domain/hostname string i.e. a sequence of
valid domain-labels, joined by dots, terminating in a TLD.

To capture the hostnames matched, use the standard Regexp::Common {-keep} option
e.g.

    @hostnames = $text =~ m/$RE{domain}{hostname}{-keep}/og;

This pattern begins and ends with a \b word-break pattern, and is
case-insensitive. 

=back

=head1 SEE ALSO

L<Regexp::Common>, L<Domain::PublicSuffix>, L<Net::Domain::TLD>

=head1 AUTHOR

Gavin Carr <gavin@openfusion.com.au>

=head1 LICENSE AND COPYRIGHT

Copyright 2012-2014 Gavin Carr.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
