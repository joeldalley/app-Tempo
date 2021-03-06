
# Display subclass for the charts page.
# @author Joel Dalley
# @version 2013/Oct/13

package Tempo::Display::Charts;

use parent 'Tempo::Display';

use JBD::Core::stern;
use Tempo::Display::Chart 'new_from';

#//////////////////////////////////////////////////////////////
# Object Interface ////////////////////////////////////////////

# @param Tempo::Display::Charts $this
# @return string    html
sub charts {
    my $this = shift;

    # currently loaded charts html
    my $total = new_from('Total', $this)->chart;
    my $annual = new_from('Annual', $this)->chart;
    my $foot_total = new_from('Footwear', $this)->chart;
    my $runs_of_dist = new_from('RunsOfDistance', $this)->chart;
    my $monthly_all_time = new_from('MonthlyAllTime', $this)->chart;
    my $quarterly = new_from('Quarterly', $this)->chart;

    # ajax html - deferred loading
    my $chart = Tempo::Display::Chart->from($this);
    my $by_foot = $chart->ajax_html('Quarterly::ByFootwear');
    my $by_surf = $chart->ajax_html('Quarterly::BySurface');
    my $by_day = $chart->ajax_html('Quarterly::ByDay');
    my $avg_dist = $chart->ajax_html('Quarterly::AverageDistance');

    $this->show('charts-container.html',
        '<!--TOTAL-->'            => $total,
        '<!--ANNUAL-->'           => $annual,
        '<!--FOOT-TOTAL-->'       => $foot_total,
        '<!--RUNS-OF-DIST-->'     => $runs_of_dist,
        '<!--MONTHLY-ALL-TIME-->' => $monthly_all_time,
        '<!--QUARTERLY-->'        => $quarterly,
        '<!--BY-FOOTWEAR-->'      => $by_foot,
        '<!--BY-SURFACE-->'       => $by_surf,
        '<!--BY-DAY-->'           => $by_day,
        '<!--AVG-DISTANCE-->'     => $avg_dist
    );
}

1;
