
# Total miles run per distinct footwear.
# @author Joel Dalley
# @version 2015/Apr/06

package Tempo::Display::Chart::Footwear;

use parent 'Tempo::Display::Chart';

use JBD::Core::stern;
use context 'footwear';
use Tempo::Color 'color_list';
use Tempo::Data 'FOOT';
use JSON 'to_json';

#//////////////////////////////////////////////////////////////
# Interface ///////////////////////////////////////////////////

# @param Tempo::Display::Chart::Footwear $this
# @return string    container + chart html
sub chart {
    my $this = shift;

    my @pairs;
    for my $foot (@{footwear()}) {
        my $filter = sub {$_->[FOOT] eq $foot}; 
        my $dist = $this->data->how_far($filter);
        push @pairs, {title => $foot, value => $dist};
    }

    my @colors = color_list(__PACKAGE__ . time, scalar @pairs);
    my $json = to_json(\@pairs);

    $this->_chart('pie-chart.html',
        '<!--CHART-TITLE-->' => 'Footwear Miles Run',
        '<!--DIV-ID-->'      => 'footwear-chart',
        '<!--COLORS-->'      => join (',', map qq/"$_"/, @colors),
        '<!--JSON-->'        => $json,
    );
}

1;
