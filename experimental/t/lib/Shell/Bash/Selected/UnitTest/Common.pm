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
    new_menu_to_five
    test_menu_to_five
);

our %EXPORT_TAGS = (
    constants => [qw($SHELL_CMD_TO $DEFAULT_MENU_PROMPT $RUN_CMD)],
    methods => [qw(new_menu_to_five test_menu_to_five)],
);
push @{$EXPORT_TAGS{'all'}}, @{$EXPORT_TAGS{ $_ }}
    foreach qw(constants methods);

Readonly our $SHELL_CMD_TO => 10;
Readonly our $DEFAULT_MENU_PROMPT => '#? ';
Readonly our $RUN_CMD => "$Bin/../selected.bash";

sub new_menu_to_five {
    Readonly my @MENU_OPTS => qw(one two three four five);
    my @other_opts = @_;
    my $exp = Expect->new;
    $exp->log_stdout(0);
    $exp->spawn($RUN_CMD, @other_opts, @MENU_OPTS);

    return $exp;
}

sub test_menu_to_five {
    my (    $test_description, $menu_selection,
            $selection_re, $selection_description,
            $opts
    ) = @_;
    my $exp = $opts->{exp} //
        new_menu_to_five($opts->{optarg} // ());
    my $pat_idx;

    subtest $test_description, sub {
        plan tests => 2;
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
    };
}

1;

