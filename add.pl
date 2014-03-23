#!/usr/bin/env perl

# Presents a form to add a run to the data set.
# @author Joel Dalley
# @version 2013/Nov/16

use lib 'libs';

use context qw(tmpl_dir run_data footwear surfaces);
use CGI qw(redirect header param);

use JBD::Tempo::Display::AddForm;
use JBD::Tempo::Passkey;
use JBD::Core::stern;

# quote-unquote security
my $key = param('passkey') || '';
$key eq $JBD::Tempo::Passkey::KEY or do {
    print redirect '/';
    exit;
};

my $disp = JBD::Tempo::Display::AddForm->new(tmpl_dir, run_data);

param('mode') or do {
    print header(-charset => 'utf-8'), 
          $disp->form($key, footwear, surfaces);
    exit;
};
param('mode') eq 'insert' and do {
    $disp->data->add_run(
        $disp->date->formatted('%F'),
        param('distance'), 
        param('surface'),
        param('footwear')
    );

    print redirect '/recent';
    exit;
};
