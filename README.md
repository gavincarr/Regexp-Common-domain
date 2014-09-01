# NAME

Regexp::Common::domain - Patterns for matching DNS domains and TLDs

# SYNOPSIS

    use Regexp::Common qw(domain);

    @tlds      = $text =~ m/$RE{domain}{tld}{-keep}/og;
    @hostnames = $text =~ m/$RE{domain}{hostname}{-keep}/og;

# DESCRIPTION

Please see [Regexp::Common](https://metacpan.org/pod/Regexp::Common) for a general description of the $RE
inteface. You do not load it directly, but via Regexp::Common, as in the
`use` statement in the SYNOPSIS.

This module provides regular expressions for matching and capturing
domains/hostnames and top-level-domains (TLDs) used by the Domain
Name System.

- $RE{domain}{tld}

    Returns a pattern that matches any TLD defined in [Net::Domain::TLD](https://metacpan.org/pod/Net::Domain::TLD) or
    [Domain::PublicSuffix](https://metacpan.org/pod/Domain::PublicSuffix) (since neither seem exhaustive alone).

    To capture the TLDs matched, use the standard Regexp::Common {-keep} option
    e.g.

        @tlds = $text =~ m/$RE{domain}{tld}{-keep}/og;

    This pattern begins and ends with a \\b word-break pattern, and is
    case-insensitive. 

    If you don't want to match standalone TLDs (which now include many ordinary
    words e.g. agency associates autos beer best bike etc.) you should anchor
    the pattern e.g. with a dot in a zero-length lookbehind assertion i.e.

        @tlds = $text =~ m/ (?<=\.) $RE{domain}{tld}{-keep}/ogx;

- $RE{domain}{hostname}

    Returns a pattern that matches a domain/hostname string i.e. a sequence of
    valid domain-labels, joined by dots, terminating in a TLD.

    To capture the hostnames matched, use the standard Regexp::Common {-keep} option
    e.g.

        @hostnames = $text =~ m/$RE{domain}{hostname}{-keep}/og;

    This pattern begins and ends with a \\b word-break pattern, and is
    case-insensitive. 

# SEE ALSO

[Regexp::Common](https://metacpan.org/pod/Regexp::Common), [Domain::PublicSuffix](https://metacpan.org/pod/Domain::PublicSuffix), [Net::Domain::TLD](https://metacpan.org/pod/Net::Domain::TLD)

# AUTHOR

Gavin Carr <gavin@openfusion.com.au>

# LICENSE AND COPYRIGHT

Copyright 2012-2014 Gavin Carr.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
