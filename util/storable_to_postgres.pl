use strict;
use warnings;

# Copy storable data into postgres.
# @author Joel Dalley
# @version 2014/Apr/06

use lib '../libs';

use JBD::Core::Storable;
use Tempo::Data;

my $data = Tempo::Data->new;

my $store_file = '../../scripts/run_log/2014-04-06.rundata.store';
my $stored = JBD::Core::Storable->new($store_file)->load;

for my $row (@$stored) {
    # EXAMPLE ROW: 2014-02-12 7 Running Trail MX20v3 Minimus
    eval { $data->add_run(@$row) };
    warn $@ if $@;
}
