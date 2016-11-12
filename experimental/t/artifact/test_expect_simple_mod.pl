#!/usr/bin/perl -w

use strict;
use warnings;

use FindBin qw($Bin);
use File::Basename;

use Test::Expect;
use Test::More;

my $script_run_dir = dirname $Bin;

print "$script_run_dir/selected\n";

my $obj = Expect::Simple->new(
    {   Cmd           => "$script_run_dir/selected",
        Prompt        => 'choice number: ',
        DisconnectCmd => "2",
        Verbose       => 0,
        Debug         => 0,
        Timeout       => 100
    }
);

die $obj->error if $obj->error;

#$obj->send('2');
print 'before: ', $obj->before;
print 'after: ', $obj->after;
print 'match str: ', $obj->match_str, "\n";
print 'match idx: ', $obj->match_idx, "\n";
print 'error from expect: ', $obj->error_expect;
print 'error: ', $obj->error;

