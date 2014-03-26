#!/usr/bin/env perl

# Presents a form to add a run to the data set.
# @author Joel Dalley
# @version 2013/Nov/16

use lib 'libs';

use context qw(passkey tmpl_dir run_data footwear surfaces);
use CGI qw(redirect header param);
use Tempo::Display::AddForm;
use JBD::Core::stern;

# quote-unquote security
my $attempt = param('passkey') || '';
my $passkey = passkey or die 'No passkey';
$attempt eq $passkey or do { print redirect '/'; exit };

my $disp = Tempo::Display::AddForm->new(tmpl_dir, run_data);

param('mode') or do {
    print header(-charset => 'utf-8'), 
          $disp->form($passkey, footwear, surfaces);
    exit;
};
param('mode') eq 'insert' and do {
    $disp->data->add_run(
        param('date') || $disp->date->formatted('%F'),
        param('distance'), 
        param('surface'),
        param('footwear')
    );

    print redirect '/recent';
    exit;
};
