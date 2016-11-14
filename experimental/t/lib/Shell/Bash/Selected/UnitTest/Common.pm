package Shell::Bash::Selected::UnitTest::Common;

use strict;
use warnings;

use Test::More;
use Readonly;
use FindBin qw($Bin);

use parent qw(Exporter); 

our @EXPORT_OK = qw(
    $SHELL_CMD_TO
    $DEFAULT_MENU_PROMPT
    $RUN_CMD
    new_menu_to_three
    new_menu_to_five
    test_menu_to_three
    test_menu_to_five
);

our %EXPORT_TAGS = (
    constants => [qw($SHELL_CMD_TO $DEFAULT_MENU_PROMPT $RUN_CMD)],
    methods => [qw(
        new_menu_to_three new_menu_to_five
        test_menu_to_three test_menu_to_five
    )],
);
push @{$EXPORT_TAGS{'all'}}, @{$EXPORT_TAGS{ $_ }}
    foreach qw(constants methods);

Readonly our $SHELL_CMD_TO => 10;
Readonly our $DEFAULT_MENU_PROMPT => '#? ';
Readonly our $RUN_CMD => "$Bin/../selected.bash";

sub new_menu_to_n {
    my $n = shift;
    my @other_opts = @_;

    Readonly my @MENU_OPTS => qw(one two three four five);
    die "Didn't learn to count as high as $n"
        if ($n > @MENU_OPTS);

    my $exp = Expect->new;
    $exp->log_stdout(0);
    $exp->spawn($RUN_CMD, @other_opts, @MENU_OPTS[0 .. $n -1]);

    return $exp;
}

sub new_menu_to_three { new_menu_to_n(3, @_) }

sub new_menu_to_five { new_menu_to_n(5, @_) }

sub test_menu_to_n {
    my (    $n, $test_description, $menu_selection,
            $selection_re, $selection_description,
            $opts
    ) = @_;
    my $exp = $opts->{exp} //
        new_menu_to_n($n, $opts->{optarg} // ());
    my $pat_idx;

    subtest $test_description, sub {
        plan tests => 2 + (exists $opts->{exit_status} ? 2 : 0);
        is( $pat_idx = $exp->expect($SHELL_CMD_TO, $DEFAULT_MENU_PROMPT),
            1, 'got prompt'
        );
        $exp->send($menu_selection);
        is( $pat_idx = $exp->expect(
                $SHELL_CMD_TO,
                ref($selection_re) eq 'Regexp' ?
                    [ $selection_re, sub {} ] :
                    ('-re', $selection_re)
            ), 1, $selection_description
        );

        if (exists $opts->{exit_status}) {
            my (undef, $expect_error) =
                $exp->expect($SHELL_CMD_TO, $DEFAULT_MENU_PROMPT);
            like(   $expect_error, qr/\bEOF\b|\bChild\b.*\bexited\b/i,
                    'selected exited after output'
            );
            is( $exp->exitstatus, $opts->{exit_status},
                'exit status of ' . $exp->exitstatus . ' matched expectations');
        }
    };

    return $exp;
}

sub test_menu_to_three { test_menu_to_n(3, @_) }
sub test_menu_to_five { test_menu_to_n(5, @_) }

1;

