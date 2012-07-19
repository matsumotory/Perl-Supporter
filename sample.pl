#!/usr/bin/perl
#############################################################################################
#
#   Sample Script Using My Perl Module
#       Copyright (C) 2012 MATSUMOTO, Ryosuke
#
#   This Code was written by matsumoto_r                 in 2012/07/13 -
#
#############################################################################################
#
# Change Log
#
# 2012/07/14 matsumoto_r first release
#
#############################################################################################

use strict;
use warnings;
use File::Spec;
use File::Basename;
use Cwd;
use lib "./lib";
use Supporter;

our $VERSION        = '0.01';
our $SCRIPT         = basename($0);
our $CDIR           = Cwd::getcwd;

our $SUPPORTER = Supporter->new(

    debug               =>  0,
    info                =>  1,
    warn                =>  1,
    error               =>  1,
    tool_name           =>  "$SCRIPT-$VERSION",
    syslog_type         =>  "$SCRIPT-$VERSION",
    log_file            =>  File::Spec->catfile($CDIR, "$SCRIPT-$VERSION.log"),
    pid_file            =>  File::Spec->catfile($CDIR, "$SCRIPT-$VERSION.pid"),
    lock_file           =>  File::Spec->catfile($CDIR, "$SCRIPT-$VERSION.lock"),

);

$SIG{INT}  = sub { $SUPPORTER->TASK_SIGINT };
$SIG{TERM} = sub { $SUPPORTER->TASK_SIGTERM };

$SUPPORTER->info_record(__PACKAGE__." $SCRIPT($VERSION) start");

$SUPPORTER->info_record(__PACKAGE__." $SCRIPT locked");
$SUPPORTER->set_lock;
$SUPPORTER->make_pid_file;

# write code

$SUPPORTER->info_record(__PACKAGE__." $SCRIPT($VERSION) end");

exit 0;
