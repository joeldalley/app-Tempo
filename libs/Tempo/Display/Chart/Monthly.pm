
# Monthly miles run chart.
# @author Joel Dalley
# @version 2013/Nov/16

package Tempo::Display::Chart::Monthly;

use parent 'Tempo::Display::Chart';

use JBD::Core::stern;
use JBD::Core::Date;
use Tempo::Color 'next_color';
use Tempo::Data 'DATE';
use JSON 'to_json';


#//////////////////////////////////////////////////////////////
# Interface ///////////////////////////////////////////////////

# @param Tempo::Display::Chart::Monthly $this
# @param int $Y   a year, YYYY
# @return hash    template replacements
sub chart {
    my ($this, $Y) = @_;

    my @data = map {{
        miles => $this->_dist($Y, $_),
        month => JBD::Core::Date->new_from_Ymd("$Y-$_-01")->month_abbr,
        color => next_color(__PACKAGE__ . $Y . time)
        }} (1 .. 12);

    $this->_chart('serial-chart.html',
        '<!--CHART-TITLE-->'    => "Monthly Miles Run ($Y)",
        '<!--DIV-ID-->'         => "month-miles-$Y",
        '<!--JSON-->'           => to_json(\@data),
        '<!--CATEGORY-TITLE-->' => 'Months',
        '<!--CATEGORY-FIELD-->' => 'month',
        '<!--VALUE-TITLE-->'    => 'Miles Run',
        '<!--VALUE-FIELD-->'    => 'miles'
    );
}


#//////////////////////////////////////////////////////////////
# Internal use ////////////////////////////////////////////////

# @param Tempo::Display::Chart::Monthly $this
# @param int $Y    a year, YYYY
# @param int $m    a month, m or M
# @return float    a number of miles
sub _dist {
    my ($this, $Y, $m) = @_;
    my $Ym = "$Y-" . sprintf('%02d', $m);
    $this->data->how_far(sub {index($_->[DATE], $Ym) == 0});
}

1;
