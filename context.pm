
# Contexual data for a Tempo instance.
# @author Joel Dalley
# @version 2013/Nov/16

# Location of JBD::x modules.
use lib 'lib';

package context;
use JBD::Core::stern;

use Exporter 'import';
our @EXPORT_OK = qw(tmpl_dir run_data footwear surfaces);

# Location of template files.
sub tmpl_dir { 'tmpl' }

# Location of Storable run data file.
sub run_data { 'db/rundata.store' }

# Footwear which occurs in data set, 
# and which will appear on the add form.
sub footwear {[
    'Wave Universe 4',
    'Wave Universe 3',
    'MX20v3 Minimus',
    'MT110',
    'MT101',
    'Trail Minimus',
    'Wave Nirvana 5',
    'Barefoot'
]}

# Surfaces which occur in the data set,
# and which will appear on the add form.
sub surfaces {[
    'Running Trail',
    'Mountain Trail',
    'Paved Road',
    'Treadmill'
]}

1;
