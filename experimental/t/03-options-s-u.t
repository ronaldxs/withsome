#!/usr/bin/perl -w

use strict;
use warnings;

use FindBin qw($Bin);

use Test::Expect;
use Test::More;

use lib "$Bin/lib";
use Shell::Bash::Selected::UnitTest::Common qw(:all);

test_menu_to_five(
    'select five and two from menu with -s', "5 2\n",
    qr/^ two \r? $ \v? ^ five \r? $/xmi,
    'selected menu items two and five',
    {optarg => '-s'}
);

test_menu_to_five(
    'select five and two from menu with -u', "5 2\n",
    qr/^ five \r? $ \v? ^ two \r? $/xmi, 
    'selected menu items two and five',
    {optarg => '-u'}
);

my ($exp, $pat_idx);

# three tests so no test_menu_to_five
$exp = new_menu_to_five('-u');

subtest 'select five (twice) and two from menu with -u', sub {
    plan tests => 3;

    is( $pat_idx = $exp->expect($SHELL_CMD_TO, $DEFAULT_MENU_PROMPT),
        1, 'got prompt'
    );
    $exp->send("5 2 5\n");
    is( $pat_idx = $exp->expect(
            $SHELL_CMD_TO,
            [ qr/\Qmore than once\E/xi, sub {} ]
        ), 1, 'more than once error'
    );
    is( $pat_idx = $exp->expect($SHELL_CMD_TO, $DEFAULT_MENU_PROMPT),
        1, 'got prompt again'
    );
};

test_menu_to_five(
    'select five (twice) and two from menu WITHOUT -u', "5 2 5\n",
    qr/^ five \r? $ \v? ^ two \r? $ \v ^ five \r? $/xmi,
    'selected item five twice and two once'
);

# test a different sort path in the code
test_menu_to_five(
    'select five and two from menu with -s -u', "5 2\n",
    qr/^ two \r? $ \v? ^ five \r? $/xmi,
    'selected items two and five',
    { optarg => '-su' }
);

done_testing();

