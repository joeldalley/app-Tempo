use strict;
use warnings;

# Simple postgres check script.
# This script should work equally well on my
# local dev machine, as it does on openshift.
# @author Joel Dalley
# @version 2014/Apr/06

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
my $dbh = DBI->connect($dsn, $user, $pass);

# Simple check: Dump all rows from runlong.
my $res = $dbh->selectall_arrayref('select * from runlog') or die $!;
for my $row (@$res) { print Dumper $row }
