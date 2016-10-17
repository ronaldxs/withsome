#!/usr/bin/env perl

use strict;
use warnings;

use Pod::Html;

my $html_tmp_fname = "withsome_tmp_$$.html";

# convert pod to html in a tmp file (because pod2html does not allow
# for redirecting stdout to a variable)
pod2html(
  '--infile=withsome.pod',
  "--outfile=$html_tmp_fname",
   '--title=withsome | Unix utility'
);

# read in the tmp html file
open my $html_tmp_fh, $html_tmp_fname or
  die "Could not open $html_tmp_fname for reading: $!";

my $html_text;
{
  local $/;
  $html_text = <$html_tmp_fh>;
}
close $html_tmp_fh or
  warn "Could not close $html_tmp_fname: $!";
unlink $html_tmp_fname or
  warn "Could not unlink $html_tmp_fname: $!";
unlink 'pod2htmd.tmp' or
  warn "Could not unlink pod2htmd.tmp (pod2html work file): $!";

# add the meta description
$html_text =~ s!
  (<title>.*?</title>)
!$1\n<meta name="description" content="withsome ... with some file name run a command on matching nearby files">!xsi;

# write the revised html to withsome.html
open my $result_fh, '>', 'withsome.html' or
  die "Could not open withsome.html for write: $!";
print $result_fh $html_text;
close $result_fh or
  warn "Could not close withsome.html: $!"; 
