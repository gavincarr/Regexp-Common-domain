use inc::Module::Install;

name     'Regexp-Common-domain';
all_from 'lib/Regexp/Common/domain.pm';
license  'perl';

build_requires 'Test::More';
build_requires 'Test::Deep';

requires 'Regexp::Common';
requires 'Domain::PublicSuffix';
requires 'Net::LibIDN';

auto_install;

WriteAll;

