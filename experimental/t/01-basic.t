#!/usr/bin/perl -w

use strict;
use warnings;

use FindBin qw($Bin);

use Test::Expect;
use Test::More;

use lib "$Bin/lib";
use Shell::Bash::Selected::UnitTest::Common qw(:all);

my $pat_idx;

my $exp = new_menu_to_five();
is( $pat_idx = $exp->expect($SHELL_CMD_TO, 'four'), 1,
    'found four on menu'
);

test_menu_to_five(
    'select two from menu', "2\n",
    '^two\r?$', 'selected menu item two',
    {exp => $exp}
);

my (undef, $expect_error) = $exp->expect($SHELL_CMD_TO, $DEFAULT_MENU_PROMPT);
like($expect_error, qr/\bEOF\b/, 'selected exited after output');
is($exp->exitstatus, 0, 'normal exit status 0');

sub reject_invalid_single_choice {
    my ($test_description, $single_choice) = @_;

    test_menu_to_five(
        $test_description, "$single_choice\n",
        qr/^ \QInvalid choice: $single_choice. Try again.\E \r? $/xm,
        'menu choice correctly rejected'
    );
}

reject_invalid_single_choice('reject letter a', 'a');
reject_invalid_single_choice('reject 9', '9');
reject_invalid_single_choice('reject 3.5', '3.5');

$exp = test_menu_to_five(
    'select two and five from menu', "2 5\n",
    qr/^ two \r? $ \v? ^ five \r? $/xmi,
    'selected menu items two and five',
    {exit_status => 0}
);

test_menu_to_five(
    'select five and two from menu', "5 2\n",
    qr/^ five \r? $ \v? ^ two \r? $/xmi,
    'selected menu items two and five'
);

done_testing();
