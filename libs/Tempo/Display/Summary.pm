
# Display subclass for the summary page.
# @author Joel Dalley
# @version 2013/Oct/13

package Tempo::Display::Summary;

use parent 'Tempo::Display';

use JBD::Core::stern;
use Tempo::Display::Chart 'new_from';
use Tempo::Display::Log;


#//////////////////////////////////////////////////////////////
# Object Interface ////////////////////////////////////////////

# @param Tempo::Display::Summary $this
# @return string    html
sub summary {
    my $this = shift;

    my $log = Tempo::Display::Log->from($this);
    my $monthly = new_from('Monthly', $this);
    my $weekly = new_from('Weekly', $this);
    my $recent = new_from('Recent', $this);

    $this->show('summary-container.html',
        '<!--RECENT-CHART-->'    => $recent->chart,
        '<!--WEEKLY-CHART-->'    => $weekly->chart(7),
        '<!--MONTHLY-CHART-->'   => $monthly->chart($this->date->Y),
        '<!--RECENT-LOG-->'      => $log->log(20)
    );
}

1;
