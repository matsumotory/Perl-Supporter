#!/usr/bin/perl
#############################################################################################
#
# package
#
#############################################################################################

package Supporter::Command;

use strict;
use vars qw($VERSION);
$VERSION = '0.01';

sub exec_command {

    my ($self, $command, $code) = @_;

    $code = 0 if !defined $code || $code eq "";

    $self->error_record(__PACKAGE__." [exec_command] command not found.", 31, $self->error) if !defined($command) || $command eq "";
    $self->debug_record(__PACKAGE__." [exec_command] exec command=$command.");

    my $output = `$command`;
    my $retval = $? >> 8;

    chomp($output);

    $self->error_record(__PACKAGE__." system exec failed. command=($command) output=($output)", $retval, $self->error) if ($retval != $code);

    return ($output, $retval);

}

1;
