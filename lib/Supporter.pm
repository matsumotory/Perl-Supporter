#!/usr/bin/perl
#############################################################################################
#
# package
#
#############################################################################################

package Supporter;

use strict;
use base "Super";
use base qw(
    Supporter::File
    Supporter::Command
    Supporter::Log
    Supporter::Record
    Supporter::Message
    Supporter::Pid
    Supporter::Lock
);

__PACKAGE__->mk_accessors(qw(
    debug           
    info            
    warn            
    error           
    log_file        
    log_size
    tool_name       
    syslog_type     
    syslog_priority 
    pid_file        
    lock_file       
    user_name       
    lock_fd         
    already_running 
    exit_code
));

our $VERSION = '0.01';

$ENV{'IFS'}     = '' if $ENV{'IFS'};
$ENV{'PATH'}    = '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin';
$ENV{'LC_TIME'} = 'C';
umask(022);

sub new {

    my ($class, %args) = @_;

    my $self = bless {

        debug               =>  (exists $args{debug})            ? $args{debug}             :   0,
        info                =>  (exists $args{info})             ? $args{info}              :   0,
        warn                =>  (exists $args{warn})             ? $args{warn}              :   0,
        error               =>  (exists $args{error})            ? $args{error}             :   0,
        log_file            =>  (exists $args{log_file})         ? $args{log_file}          :   "/tmp/operation-tool-$ENV{USR}.log",
        log_size            =>  (exists $args{log_size})         ? $args{log_size}          :   1000000,
        tool_name           =>  (exists $args{tool_name})        ? $args{tool_name}         :   'operation-tool',
        syslog_type         =>  (exists $args{syslog_type})      ? $args{syslog_type}       :   'operation-system',
        syslog_priority     =>  (exists $args{syslog_priority})  ? $args{syslog_priority}   :   'local3.notice',
        pid_file            =>  (exists $args{pid_file})         ? $args{pid_file}          :   '/tmp/operation-tool.pid',
        lock_file           =>  (exists $args{lock_file})        ? $args{lock_file}         :   '/tmp/operation-tool.lock',
        user_name           =>  (exists $args{user_name})        ? $args{user_name}         :   $ENV{USER},
        lock_fd             =>  undef,
        already_running     =>  0,
        exit_code           =>  0,    

    }, $class;

    $self->debug_record(__PACKAGE__." call new");
    $self->debug_record(__PACKAGE__." [new] executed.", $self->debug);
    $self->initialization;

    return $self;
}


sub initialization {

    my $self = shift;

    $self->debug_record(__PACKAGE__." call initialization");

}

sub DESTROY {

    my $self = shift;

    my $unlink_log_size = $self->log_size;

    $self->debug_record(__PACKAGE__." call destructor");
    $self->debug_record(__PACKAGE__." [DESTROY] execute unlink_pid_file and set_unlock", $self->debug);

    if ($self->already_running == 1) {
        $self->unlink_pid_file;
        $self->set_unlock;
        my $log_size = -s $self->log_file;
        unlink $self->log_file if $log_size > $unlink_log_size;
    }

    exit $self->exit_code;
}
