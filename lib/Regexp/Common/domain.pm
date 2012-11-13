package Regexp::Common::domain;

use warnings;
use strict;
use Regexp::Common qw(pattern);
#use Net::Domain::TLD qw(tlds);
use Domain::PublicSuffix;
use Net::LibIDN qw(idn_to_ascii);

our $VERSION = '0.03';

my $HOSTNAME_CHARS = "a-zA-Z0-9-";
my $HOSTNAME_CHARS_CLASS = "[$HOSTNAME_CHARS]";
my $HOSTNAME_CHARS_DOT_CLASS = "[.$HOSTNAME_CHARS]";
my $HOSTNAME_CHARS_UNDERSCORE_CLASS = "[_$HOSTNAME_CHARS]";
my $HOSTNAME_CHARS_UNDERSCORE_DOT_CLASS = "[_.$HOSTNAME_CHARS]";

my $NON_HOSTNAME_CHARS_CLASS = "[^$HOSTNAME_CHARS]";
my $NON_HOSTNAME_CHARS_DOT_CLASS = "[^.$HOSTNAME_CHARS]";
my $NON_HOSTNAME_CHARS_UNDERSCORE_CLASS = "[^_$HOSTNAME_CHARS]";
my $NON_HOSTNAME_CHARS_UNDERSCORE_DOT_CLASS = "[^_.$HOSTNAME_CHARS]";

# TLDs via Net::Domain::TLD (seems to omit new IDN TLDs)
#my $TLDs = join '|', sort(tlds('gtld_open')),
#                     sort(tlds('gtld_restricted')),
#                     sort(tlds('new_open')),
#                     sort(tlds('new_restricted')),
#                     sort(tlds('cc'));
 
# TLDs via Domain::PublicSuffix
my $dps = Domain::PublicSuffix->new;
my %tld = map { $_ => [] } qw(2 3 4);

for (sort map { idn_to_ascii($_, "utf-8") } keys %{$dps->tld_tree}) {
  # Categorise TLDs by length
  my $len = length $_;
  $len = 4 if $len > 4;
  push @{$tld{$len}}, $_;
}
my $TLDs = join '|', @{$tld{3}}, @{$tld{4}}, @{$tld{2}};

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
            # and must be followed by a non-domain character
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
            # and must be followed by a non-domain character
            "(?:(?=$NON_HOSTNAME_CHARS_UNDERSCORE_DOT_CLASS)|\$)"
  ;


1;

__END__

=head1 NAME

Regexp::Common::domain - patterns for matching domains and components

=head1 VERSION

Version 0.03

=head1 SYNOPSIS

    use Regexp::Common qw(domain);

    @tlds      = $text =~ m/$RE{domain}{tld}{-keep}/og;
    @hostnames = $text =~ m/$RE{domain}{hostname}{-keep}/og;

=head1 AUTHOR

Gavin Carr <gavin@openfusion.com.au>

=head1 BUGS

Please report any bugs or feature requests to 
C<bug-regexp-common-domain at rt.cpan.org>, or through the web interface
at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Regexp-Common-domain>.

=head1 ACKNOWLEDGEMENTS

L<Regexp::Common>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Gavin Carr.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

