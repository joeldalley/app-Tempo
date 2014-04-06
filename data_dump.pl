#!/usr/bin/env perl

# Displays the postgres data, as UTF-8 text.
# @author Joel Dalley
# @version 2014/Apr/06

use lib 'libs';

use CGI qw(redirect header param);
use JBD::Core::stern;
use context 'passkey';
use Tempo::Data;

# quote-unquote security
my $attempt = param('passkey') || '';
my $passkey = passkey or die 'No passkey';
$attempt eq $passkey or do { print redirect '/'; exit };

print header(-charset       => 'utf-8', 
            '-content-type' => 'text/plain');

# Print every row in the runlog table as a CSV record.
my @copy = Tempo::Data->new->copy or do {
    print "$!\n";
    warn $!;
    exit;
};
print join(',', map qq|"$_"|, @$_), "\n" for @copy;
