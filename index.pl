#!/usr/bin/env perl

# Print Tempo page.
# @author Joel Dalley
# @version 2013/Nov/16

use lib 'lib';
use JBD::Core::stern;
use JBD::Tempo::Router 'get';
use JBD::Tempo::Display;
use CGI qw(header redirect param);

# Location of template files.
sub tmpl_dir { 'tmpl' }

# Location of Storable run data file.
sub run_data { 'db/rundata.store' }


my $disp = JBD::Tempo::Display->new(tmpl_dir, run_data);
my %params = map {$_ => param($_) || ''} qw(route chart);

my $content = get $disp, %params or do {
    print redirect '/';
    exit;
};
print header(-charset => 'utf-8'), $content;
