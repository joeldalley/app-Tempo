
# Subs for coloring charts.
# @author Joel Dalley
# @version 2013/Oct/12

package Tempo::Color;

use JBD::Core::stern;

use Exporter 'import';
our @EXPORT_OK = qw(next_color color_list);

my @palette = (
    '7C0D20', '910D23', 'A63045',                     # reds
    'B4A47A', 'CAB37A', 'E0B787', 'E5C99D', 'F3E8BC', # yellows
    '1E395B', '33476D', '4D70C0', '5795E6', '77B5EF', # blues
    );

# for next_color()
my %copy;


#//////////////////////////////////////////////////////////////
# Interface ///////////////////////////////////////////////////

# @param string $key    an iterator key
# @return string    hex color
sub next_color($) {
    my $k = shift;
    $copy{$k} = [@palette] unless $copy{$k} && @{$copy{$k}};
    '#' . pop @{$copy{$k}};
}

# @param string $key    an iterator key
# @param int $how_many    how many in the list
# @return array    array of hex colors
sub color_list($$) {
    my ($key, $how_many) = @_;
    map next_color($key), (1 .. $how_many);
}

1;
