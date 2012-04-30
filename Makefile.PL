use inc::Module::Install;

name     'Regexp-Common-domain';
all_from 'lib/Regexp/Common/domain.pm';
author   q{Gavin Carr <gavin@openfusion.com.au>};
license  'perl';

build_requires 'Test::More';

requires 'Regexp::Common';
#requires 'Net::Domain::TLD';
requires 'Domain::PublicSuffix';
requires 'Net::LibIDN';

auto_install;

WriteAll;

