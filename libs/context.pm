
# Contexual data for a Tempo instance.
# @author Joel Dalley
# @version 2013/Nov/16

package context;

use Cwd 'abs_path';
use File::Slurp 'read_file';
use File::Basename 'dirname';

use JBD::Core::stern;
use JBD::Core::Exporter;
use JBD::Core::String 'trim';

use constant file_path => dirname abs_path __FILE__;

our @EXPORT_OK = qw(passkey tmpl_dir run_data footwear surfaces);

# Passkey value.
sub passkey { 
    exists $ENV{HOME} or die 'No HOME in \%ENV';
    trim read_file $ENV{HOME} . '/.tempo_passkey' or die $!;
}

# Location of template files.
sub tmpl_dir { file_path . '/../tmpl' }

# Location of Storable run data file.
sub run_data { file_path . '/../db/rundata.store' }

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
