use strict;
use warnings;

# Replace runlog db table data with the data
# from a specified data dump file.
# @author Joel Dalley
# @version 2015/Feb/13

use Data::Dumper;
use DBI;

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

# Command argument: a dump file relative path to this script.
my $file = shift or die "Missing dump file.";
open my $F, '<', $file or die $!;
chomp(my @data = <$F>) or die $!;
close $F or die $!;

# Prepare read/write statements.
my $select_sth = $dbh->prepare(
    'SELECT COUNT(*) FROM runlog' .
    ' WHERE run_date=? AND distance=? AND surface=? AND footwear=?'
);
my $insert_sth = $dbh->prepare(
    'INSERT INTO runlog (run_date,distance,surface,footwear) VALUES (?,?,?,?)'
);

# Add missing data.
while (@data) {
    # Split row into values:
    my $row = pop @data;
    $row =~ s/^"//;
    $row =~ s/"$//;
    my @values = split /","/, $row;

    # If the given row isn't already in the database, add it:
    my $count = $dbh->selectcol_arrayref($select_sth, undef, @values)->[0];
    if (!$count) {
        $insert_sth->execute(@values) or die $!;
        print "INSERTED VALUES: @values\n";
    }
}
