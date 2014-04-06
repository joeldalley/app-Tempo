
# Tempo run data object.
# @author Joel Dalley
# @version 2013/Nov/16

package Tempo::Data;

use JBD::Core::Exporter ':omni';
use JBD::Core::stern;
use DBI;

# names for data field array indexes
sub DATE {0}    sub DIST {1}
sub SURF {2}    sub FOOT {3}


#//////////////////////////////////////////////////////////////
# Object Interface ////////////////////////////////////////////

# @param string $type Object type.
# @return Tempo::Data
sub new {
    my $type = shift;

    # Mimic openshift environment vars, w/ local values.
    exists $ENV{OPENSHIFT_POSTGRESQL_DB_HOST}
        or $ENV{OPENSHIFT_POSTGRESQL_DB_HOST} = 'localhost';
    exists $ENV{OPENSHIFT_POSTGRESQL_DB_PORT}
        or $ENV{OPENSHIFT_POSTGRESQL_DB_PORT} = '5432';

    # On openshift, this file contains a username and password
    # for my openshift postgres gear; locally, it has my local
    # development db user and password in it.
    chomp(my $pass_data = `cat ~/.pgpass`);
    my (undef, undef, undef, $user, $pass) = split /:/, $pass_data;

    # Connect.
    my $dsn = "DBI:Pg:dbname=tempo;"
            . "host=$ENV{OPENSHIFT_POSTGRESQL_DB_HOST};"
            . "port=$ENV{OPENSHIFT_POSTGRESQL_DB_PORT}";
    my $dbh = DBI->connect($dsn, $user, $pass) or die $!;

    bless [$dbh, undef], $type;
}

# @param Tempo::Data
# @return DBI A connected DBI.
sub dbi { shift->[0] }

# @param Tempo::Data
# @return arrayref All data rows.
sub data { shift->[1] }

# @param Tempo::Data $this
# @return array A copy of the run data.
sub copy { 
    my $this = shift;
    $this->load; @{$this->data};
}

# @param Tempo::Data $this
# @return arrayref    run data
sub load { 
    my $this = shift;
    ref $this->[1] or do {
        my $q = 'SELECT * FROM runlog ORDER BY run_date DESC';
        $this->[1] = $this->dbi->selectall_arrayref($q);
    };
    $this->data;
}


# @param Tempo::Data
# @param coderef [optional]    filtering sub, or undef
# @return float    number of miles in the filtered subset
sub how_far {
    my $set = shift->subset(shift);
    my $sum = 0; $sum += $_->[DIST] for @$set; $sum;
}

# @param Tempo::Data
# @param coderef [optional]    filtering sub, or undef
# @return int    number of runs in the filtered subset
sub how_many { scalar @{shift->subset(shift)} }

# @param Tempo::Data $this
# @param mixed $filter    a coderef, or undef
# @return arrayref    subset of run data, per $filter
sub subset {
    my ($this, $filter) = @_;
    my $data = $this->load;
    ref $filter eq 'CODE' ? [grep $filter->($_), @$data] : $data;
}


# @param Tempo::Data $this
# @param string    a Y-m-d
# @param float    number of miles
# @param string    running surface
# @param string    footwear worn
sub add_run {
    my $this = shift;

    # Add to in-memory array.
    my $data = $this->load;
    unshift @$data, [@_];

    # Add to database.
    my $q = 'INSERT INTO runlog'
          . ' (run_date,distance,surface,footwear)'
          . ' VALUES (?,?,?,?)';
    my $sth = $this->dbi->prepare($q) or die $!;
    $sth->execute(@_) or die $!;
}

# @param Tempo::Data $this
# @param arrayref $from    entries matching this
# @param arrayref $to    are replaced with this
sub replace_run {
    my ($this, $from, $to) = @_;

    # Update in-memory array.
    my $data = $this->load;
    for (@$data) { $_ = $to if "@$_" eq "@$from" }

    # Update database.
    my $q = 'UPDATE runlog' 
          . ' SET run_date=?,distance=?,surface=?,footwear=?'
          . ' WHERE run_date=?,distance=?,surface=?,footwear=?';
    my $sth = $this->dbi->prepare($q);
    $sth->execute(@$to, @$from);
}


# @param Tempo::Data $this
# @return int    the year from the oldest entry
sub begin_year {
    my $this = shift;
    substr $this->load->[-1][DATE], 0, 4;
}

# @param Tempo::Data $this
# @return int    the year from the newest entry
sub end_year {
    my $this = shift;
    substr $this->load->[0][DATE], 0, 4;
}

# @param Tempo::Data $this
# @return arrayref    unique footwear in data set
sub footwear {
    my $this = shift;
    my %unique = map {$_->[FOOT] => 1} @{$this->load};
    [sort keys %unique];
}

# @param Tempo::Data $this
# @return arrayref    unique surfaces in data set
sub surfaces {
    my $this = shift;
    my %unique = map {$_->[SURF] => 1} @{$this->load};
    [sort keys %unique];
}

1;
