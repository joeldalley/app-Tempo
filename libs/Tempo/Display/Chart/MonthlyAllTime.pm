
# Monthly miles run chart, all time.
# @author Joel Dalley
# @version 2015/Apr/30

package Tempo::Display::Chart::MonthlyAllTime;

use parent 'Tempo::Display::Chart';

use JBD::Core::stern;
use JBD::Core::Date;
use Tempo::Color 'next_color';
use Tempo::Data 'DATE';
use JSON 'to_json';


#//////////////////////////////////////////////////////////////
# Interface ///////////////////////////////////////////////////

# @param Tempo::Display::Chart::MonthlyAllTime $this
# @return hash    template replacements
sub chart {
    my $this = shift;

    my $begin_year = $this->data->begin_year;
    my $end_year   = $this->data->end_year;

    my @data;
    for my $Y ($begin_year .. $end_year) {
        for my $m (1 .. 12) {
            my $miles = $this->_dist($Y, $m) or next;
            my $month_abbr = JBD::Core::Date->new_from_Ymd("$Y-$m-01")->month_abbr;

            push @data, {
                miles => $miles,
                month => "$month_abbr $Y",
                color => next_color(__PACKAGE__ . $Y . time)
            }
        }
    }

    my $title = "Monthly Miles Run ($begin_year - $end_year)";
    $this->_chart('serial-chart.html',
        '<!--CHART-TITLE-->'    => $title,
        '<!--DIV-ID-->'         => "month-miles-all-time",
        '<!--JSON-->'           => to_json(\@data),
        '<!--CATEGORY-TITLE-->' => 'Months',
        '<!--CATEGORY-FIELD-->' => 'month',
        '<!--VALUE-TITLE-->'    => 'Miles Run',
        '<!--VALUE-FIELD-->'    => 'miles'
    );
}


#//////////////////////////////////////////////////////////////
# Internal use ////////////////////////////////////////////////

# @param Tempo::Display::Chart::MonthlyAllTime $this
# @param int $Y    a year, YYYY
# @param int $m    a month, m or M
# @return float    a number of miles
sub _dist {
    my ($this, $Y, $m) = @_;
    my $Ym = "$Y-" . sprintf('%02d', $m);
    $this->data->how_far(sub {index($_->[DATE], $Ym) == 0});
}

1;
