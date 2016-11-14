#!/usr/bin/perl -w

use strict;
use warnings;

use FindBin qw($Bin);

use Test::Expect;
use Test::More;

use lib "$Bin/lib";
use Shell::Bash::Selected::UnitTest::Common qw(:all);

test_menu_to_three(
    'select all from menu', "*\n",
    qr/^ one \r? $ \v? ^ two \r? $ \v? ^ three \r? $/xmi,
    'selected menu items one through three'
);

test_menu_to_three(
    'select all from menu and two twice', "2 *\n",
    qr/^ two \r? $ \v? ^ one \r? $ \v? ^ two \r? $ \v? ^ three \r? $/xmi,
    'selected menu items two then one through three'
);

test_menu_to_three(
    'refuse select * with -n option', "2 *\n",
    qr/^ \QInvalid choice: *. Try again.\E \r? $/xm,
    'menu choice correctly rejected',
    { optarg => '-n' } 
);

foreach my $exit_command ('quit', '0') {
    my $exp = new_menu_to_three();
    subtest "say $exit_command and exit", sub {
        plan tests => 3;

        my $pat_idx;
        is( $pat_idx = $exp->expect($SHELL_CMD_TO, $DEFAULT_MENU_PROMPT),
            1, 'got prompt'
        );
        $exp->send("$exit_command\n");
        my (undef, $expect_error) =
            $exp->expect($SHELL_CMD_TO, $DEFAULT_MENU_PROMPT);
        like(   $expect_error, qr/\bEOF\b|\bChild\b.*\bexited\b/i,
                "selected exited after $exit_command"
        );
        is($exp->exitstatus, 0, 'exit status of 0');
    };
}

done_testing();

