
# Number of runs of at least X distance.
# @author Joel Dalley
# @version 2015/Jul/04

package Tempo::Display::Chart::RunsOfDistance;

use parent 'Tempo::Display::Chart';

use JBD::Core::stern;
use Tempo::Color 'color_list';
use Tempo::Data 'DIST';
use JSON 'to_json';

#//////////////////////////////////////////////////////////////
# Interface ///////////////////////////////////////////////////

# @param Tempo::Display::Chart::RunsOfDistance $this
# @return string    container + chart html
sub chart {
    my $this = shift;

    my @distances = (10, 12, 13, 15, 18, 20, 26.2, 30);

    my @pairs;
    for my $dist (@distances) {
        my $filter = sub {$_->[DIST] >= $dist}; 
        my $count = $this->data->how_many($filter);
        push @pairs, {title => $dist, value => $count};
    }

    my @colors = color_list(__PACKAGE__ . time, scalar @pairs);
    my $json = to_json(\@pairs);

    $this->_chart('pie-chart.html',
        '<!--CHART-TITLE-->' => 'Number of Runs of at Least X Distance',
        '<!--DIV-ID-->'      => 'runs-of-distance-chart',
        '<!--COLORS-->'      => join (',', map qq/"$_"/, @colors),
        '<!--JSON-->'        => $json,
    );
}

1;
