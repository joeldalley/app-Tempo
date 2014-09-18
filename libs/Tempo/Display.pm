
# Tempo Display class.
# @author Joel Dalley
# @version 2013/Nov/15

package Tempo::Display;

use JBD::Core::stern;
use JBD::Core::Display;
use JBD::Core::Date;
use Tempo::Data;
use HTML::Entities;

#//////////////////////////////////////////////////////////////
# Interface ///////////////////////////////////////////////////

# @param string $type    object type
# @param string $tmpl_dir    path to template files
# @return Tempo::Display
sub new {
    my ($type, $tmpl_dir) = @_;

    bless [
        JBD::Core::Display->new($tmpl_dir),
        Tempo::Data->new,
        JBD::Core::Date->new
        ], $type;
}

# @param string $type    object type
# @param Tempo::Display $source    source object
# @return Tempo::Display
sub from {
    my ($type, $source) = @_;
    bless [@$source], $type;
}

# @param Tempo::Display
# @param string    a template file
# @param hash [optional]   template replacements
# @return string    html
sub show { 
    my $this = shift;
    $this->[0]->(@_);
}

# @param Tempo::Display
# @return Tempo::Data
sub data { shift->[1] }

# @param Tempo::Display
# @return JBD::Core::Date
sub date { shift->[2] }

# @param Tempo::Display $this
# @param string $h1    page H1 header
# @param string $content   page content
# @return string    page html
sub page {
    my ($this, $h1, $content) = @_;
    return $this->open($h1)
         . $this->h1($h1)
         . $this->content($content)
         . $this->close;
}

# @param Tempo::Display $this
# @param string [optional] $subtitle    page subtitle, or undef
# @return string    page open html
sub open {
    my ($this, $subtitle) = @_;

    my $title = "Joel Dalley's Running Site";
    $title = join ' :: ', $title, $subtitle if $subtitle;

    $this->show('page-open.html',
        '<!--TITLE-->'      => $title,
        '<!--BANNER-ALT-->' => $title
    );
}

# @param Tempo::Display $this
# @param string $h1    H1 header
# @return string    H1 header html
sub h1 { 
    my ($this, $h1) = @_;
    $this->show('h1.html', '<!--H1-->' => encode_entities($h1));
}

# @param Tempo::Display $this
# @param string $content    page content
# @return string    page content html
sub content {
    my ($this, $content) = @_;
    $this->show('content.html', '<!--CONTENT-->' => $content);
}

# @param Tempo::Display $this
# @return string    page close html
sub close {
    my $this = shift;
    $this->show('page-close.html',
        '<!--COPY-YEAR-->' => $this->date->Y
    );
}

1;
