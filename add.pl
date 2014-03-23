#!/usr/bin/env perl

# Presents a form to add a run to the data set.
# @author Joel Dalley
# @version 2013/Nov/16

# Location of template files.
sub tmpl_dir { 'tmpl' }

# Location of Storable run data file.
sub run_data { 'db/rundata.store' }

# Footwear which occurs in data set, 
# and which will appear on the add form.
sub footwear {[
    'Wave Universe 4',
    'Wave Universe 3',
    'MX20v3 Minimus',
    'MT110',
    'MT101',
    'Trail Minimus',
    'Wave Nirvana 5',
    'Barefoot'
]}

# Surfaces which occur in the data set,
# and which will appear on the add form.
sub surfaces {[
    'Running Trail',
    'Mountain Trail',
    'Paved Road',
    'Treadmill'
]}

use lib 'lib';
use JBD::Core::stern;
use JBD::Tempo::Display::AddForm;
use JBD::Tempo::Passkey;
use CGI qw(redirect header param);

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
