#!/usr/bin/perl -w

use strict;
use warnings;

use FindBin qw($Bin);

use Test::Expect;
use Test::More;

use lib "$Bin/lib";
use Shell::Bash::Selected::UnitTest::Common qw(:all);

my $exp = Expect->new;
$exp->log_stdout(0);
$exp->spawn("/usr/bin/env bash -c '$RUN_CMD -a<(cd $Bin/ls-menu;ls)'");
subtest 'get menu from file names', sub {
    plan tests => 2;
    my $pat_idx;

    is( $pat_idx = $exp->expect($SHELL_CMD_TO, $DEFAULT_MENU_PROMPT),
        1, 'got prompt'
    );
    $exp->send("1 5\n");
    is( $pat_idx = $exp->expect(
            $SHELL_CMD_TO,
            [   qr/^    \Qa file name with spaces.txt\E \r? $ \v?
                        \Qsource-file.C\E \r? $
                /xsmi,
                sub {}
            ]
        ), 1, 'selected menu items one and five from directory'
    );
};

$exp = Expect->new;
$exp->log_stdout(0);
$exp->spawn(qq!/usr/bin/env bash -c "echo 1 5 | xargs -a<(cd $Bin/ls-menu;ls) -d'\\n' $RUN_CMD -x"!);

my $pat_idx;
is( $pat_idx = $exp->expect(
        $SHELL_CMD_TO,
        [   qr/^    \Qa file name with spaces.txt\E \r? $ \v?
                    \Qsource-file.C\E \r? $
            /xsmi,
            sub {}
        ]
    ), 1, 'automated drive of menu with xargs and pipe'
);

done_testing();
