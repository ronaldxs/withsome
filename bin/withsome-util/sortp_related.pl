#!/bin/bash

######################################################################
# Path sorting that I found difficult to do with bash at this point.
# Sorts paths by number of '/' separated direcories first and then
# does second level alphabetic sort
#
# Ronald Schmidt
#
######################################################################

perl -MFile::Basename -Mstrict -w -e '

use constant PATH_SEP => "/";

sub path_el {
    my $seg = basename $_[0];
    return $seg && ($seg !~ /^(?:\.|\.\.|\/)$/)
        ? ( path_el(dirname $_[0]), $seg ) : ();
}

sub sort_path_els {
    my @paths = sort
        {   scalar(@{$a->[1]}) <=> scalar(@{$b->[1]}) ||
            $a->[0] cmp $b->[0]
        } @_ if @_;

    my @res;
    while (@paths) {
        push @res, (shift @paths);
        my $mat_root = dirname($res[-1]->[0]) . PATH_SEP;
        my @mat_paths = grep {  index($_->[0], $mat_root) == 0   } @paths;
        @paths = grep {  index($_->[0], $mat_root) != 0   } @paths;
        my $dir_eq_count = grep { @{$_->[1]} == @{$res[-1]->[1]} } @mat_paths;
        push @res, splice @mat_paths, 0, $dir_eq_count;
        push @res, sort_path_els(@mat_paths);
    }

    return @res;
}

sub sort_paths {
    return map  { $_->[0] }
        sort_path_els( map { [ $_, [path_el($_)] ] } @_ );
}

select STDERR;
$|++;
select STDOUT;
print sort_paths(<>);

'
