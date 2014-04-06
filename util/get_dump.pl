
# Fetchs data dump, and places it in file.

use lib '../libs';

use JBD::Core::stern;
use JBD::Core::Date;

use context 'passkey';
use LWP::Simple 'get';
use File::Slurp;

my $url = 'https://tempo-joeldalley.rhcloud.com'
        . '/data_dump.pl?passkey=' . passkey;

my $text = get $url or die $!;
my $Ymd = JBD::Core::Date->new(time)->formatted('%F');
write_file "data_dump/$Ymd.dump", $text or die $!;
