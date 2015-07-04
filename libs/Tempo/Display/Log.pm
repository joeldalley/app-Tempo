
# Display subclass for the run log page.
# @author Joel Dalley
# @version 2013/Oct/06

package Tempo::Display::Log;

use parent 'Tempo::Display';

use JBD::Core::stern;
use JBD::Core::Date;
use Tempo::Data qw(DATE DIST FOOT SURF);


#//////////////////////////////////////////////////////////////
# Object interface ////////////////////////////////////////////

# @param Tempo::Display::Log $this
# @param int [optional] $size    how many rows: default all
# @return string    html
sub log {
    my ($this, $size) = @_;

    my @data = $this->data->copy;
    @data = @data[0 .. $size] if $size;

    my ($num, $rows) = (1, '');

    for (@data) { 
        $rows .= $this->_row($_, $num);
        $num += 1;
     }

    return $this->show('run-log-open.html')
         . $rows
         . $this->show('run-log-close.html');
}


#//////////////////////////////////////////////////////////////
# Internal use ////////////////////////////////////////////////

# @param object $this    a Tempo::Display::Log
# @param arrayref $row    a run log data row
# @param int $num    the run number
# @return string    html
sub _row {
    my ($this, $row, $num) = @_;
    my $date = JBD::Core::Date->new_from_Ymd($row->[DATE]);
    $this->show('run-log-row.html', 
        '<!--NUM-->'  => $num,
        '<!--DATE-->' => $date->formatted('%a, %b %o, %Y'),
        '<!--DIST-->' => $row->[DIST],
        '<!--SURF-->' => $row->[SURF],
        '<!--FOOT-->' => $row->[FOOT]
    );
}

1;
