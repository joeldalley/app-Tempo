
# Provides get(), which returns response content, per
# the requested route, with the help of a display object.
# @author Joel Dalley
# @version 2013/Nov/16

package Tempo::Router;
use JBD::Core::Exporter ':omni';

# @param Tempo::Display $disp    display object
# @param hash %params    k/v pairs of CGI/ENV data
# @return mixed    either the response content, or 0
sub get($%) {
    my ($disp, %params) = (shift, @_);
    my $route = $params{route};

    # home / recent runs page
    grep $route eq $_, ('', 'philosophy', 'recent') and do {
        require Tempo::Display::Summary;
        my $sum = Tempo::Display::Summary->from($disp);
        return $disp->page('Recent Runs', $sum->summary);
    };

    # run charts page
    $route eq 'charts' and do {
        require Tempo::Display::Charts;
        my $charts = Tempo::Display::Charts->from($disp);
        return $charts->page('Run Charts', $charts->charts);
    };

    # single chart
    $route eq 'ajax/chart' and $params{chart} and do {
        require Tempo::Display::Chart;
        my $sub = \&Tempo::Display::Chart::new_from;
        return $sub->($params{chart}, $disp)->chart;
    };

    # run log page
    $route eq 'runlog' and do {
        require Tempo::Display::Log;
        my $log = Tempo::Display::Log->from($disp);
        return $disp->page('Run Log', $log->log);
    };

    0;
}

1;
