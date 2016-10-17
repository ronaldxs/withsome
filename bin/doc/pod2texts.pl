#!/usr/bin/env perl

use strict;
use warnings;

use Pod::Html;

######################################################################
# Write $content to the file name $fname at the root of the project.
######################################################################
sub spurt_txt_file {
    my ($fname, $content) = @_;

    open my $fh, '>', "../$fname" or
        die "Could not open $fname file for writing: $!";
    print $fh $content;
    close $fh or
       die "Could not close $fname handle: $!";
}

######################################################################
# Read whole pod documentation including README, INSTALL and LICENSE.
######################################################################
open my $withsome_fh, 'pod2text withsome.pod |' or
    die "Could not open stream for pod2text withsome.pod: $!";

my $readme_txt;
{
    local $/;
    $readme_txt = <$withsome_fh>;
}
close $withsome_fh or
    die "Could not close stream for pod2text withsome.pod: $!";

######################################################################
# Create INSTALL file
######################################################################
my ($install_txt) = $readme_txt =~ /
    .*
    ^\s*INSTALLATION\s*$
    .*?
    (^\s* \S .*?)
    ^ \s* COPYRIGHT(?:(?:\s+\w+)?\s+Licensing\.?)?\s*$
    .*
/xmsi;

$install_txt =~ s/^\h\s{1,3}//smg; # remove indentation
$install_txt =~ s!(something_on_my_pa)\n(th/\n)!$1$2!;

spurt_txt_file('INSTALL', $install_txt);

######################################################################
# Create LICENSE file
######################################################################
my ($license_txt) = $readme_txt =~ /
    .*
    ^ \s* COPYRIGHT(?:(?:\s+\w+)?\s+Licensing\.?)?\s*$
    (.*)
/xmsi;

spurt_txt_file('LICENSE', $license_txt);

######################################################################
# Create README file
######################################################################
$readme_txt =~ s/
    ^(\s*INSTALLATION\s*)$
    .* 
    ^(\s*COPYRIGHT(?:(?:\s+\w+)?\s+Licensing\.?)?\s*)$
    .*
/$1
    See INSTALL file.

$2
    See LICENSE file.
/xmsi;

spurt_txt_file('README', $readme_txt);
