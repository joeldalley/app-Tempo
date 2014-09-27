
# Total miles run chart.
# @author Joel Dalley
# @version 2013/Dec/24

package Tempo::Display::Chart::Total;

use parent 'Tempo::Display::Chart';

use JBD::Core::stern;
use Tempo::Color 'color_list';
use JSON 'to_json';

#//////////////////////////////////////////////////////////////
# Interface ///////////////////////////////////////////////////

# @param Tempo::Display::Chart::Total $this
# @return string    container + chart html
sub chart {
    my $this = shift;

    my $total = sprintf '%.1f', $this->data->how_far;
    my @colors = color_list(__PACKAGE__ . time, 1);
    my $json = to_json([{title => 'Miles', value => $total}]);

    $this->_chart('pie-chart.html',
        '<!--CHART-TITLE-->' => "Total Miles Run ($total)",
        '<!--DIV-ID-->'      => 'total-chart',
        '<!--COLORS-->'      => join (',', map qq/"$_"/, @colors),
        '<!--JSON-->'        => $json,
    );
}

1;
