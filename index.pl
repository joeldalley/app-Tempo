#!/usr/bin/env perl

# Print Tempo page.
# @author Joel Dalley
# @version 2013/Nov/16

use lib 'libs';

use context qw(tmpl_dir run_data);
use CGI qw(header redirect param);

use JBD::Core::stern;
use Tempo::Display;
use Tempo::Router 'get';

my $disp = Tempo::Display->new(tmpl_dir, run_data);
my %params = map {$_ => param($_) || ''} qw(route chart);

my $content = get $disp, %params or do {
    print redirect '/';
    exit;
};
print header(-charset => 'utf-8'), $content;
