#!/usr/bin/env perl

# Print Tempo page.
# @author Joel Dalley
# @version 2013/Nov/16

use lib 'lib';
use context qw(tmpl_dir run_data);
use JBD::Core::stern;
use JBD::Tempo::Router 'get';
use JBD::Tempo::Display;

use CGI qw(header redirect param);

# display object
my $disp = JBD::Tempo::Display->new(tmpl_dir, run_data);

# CGI/ENV data used in get()
my %params = map {$_ => param($_) || ''} qw(route chart);

# response content, or redirect home
my $content = get $disp, %params or do {
    print redirect '/';
    exit;
};

# print response
print header(-charset => 'utf-8'), $content;
