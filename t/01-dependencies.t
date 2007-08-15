use strict;
$^W = 1;

use Test::More tests => 3;
use CPAN::FindDependencies 'finddeps';

# $SIG{__WARN__} = sub { }; # silently eat warnings

my $devnull; my $oldfh;
open($devnull, '>>/dev/null') && do { $oldfh = select($devnull) };
my $dist = CPAN::Shell->expand("Module", "CPAN")->{RO}->{CPAN_FILE};
select($oldfh) if($oldfh);

is_deeply([finddeps('CPAN')], [finddeps($dist)],
    "A module and its distribution have the same dependencies");

ok((finddeps('CPAN'))[0]->{RO}->{CPAN_FILE} =~ m!^A/AN/ANDK/CPAN-!,
    "First entry in lists is the module itself");

is_deeply([sort { $a cmp $b } qw(CPAN Test::More Test::Harness File::Spec Scalar::Util File::Temp)],[sort { $a cmp $b } map { $_->{ID} } finddeps('CPAN')],
    "Dependencies are correct (horribly fragile test!)");