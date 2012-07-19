#!/usr/bin/perl
#############################################################################################
#
# package
#
#############################################################################################

package Supporter::File;

use strict;
use vars qw($VERSION);
$VERSION = '0.01';


sub file_read {
    
    my ($self, $read_file) = @_;

    $self->debug_record(__PACKAGE__." reading file: $read_file");
    open(HFILE, "< $read_file") or $self->error_record(__PACKAGE__." can not open file: $read_file", 2, $self->error);
    my @contents = <HFILE>;
    close HFILE;

    return @contents;
}


sub file_write {

    my ($self, $write_file, $write_type, $write_str)  = @_;

    my $type = "";

    if ($write_type eq "a") {
        $type = ">>";
    } elsif ($write_type eq "w") {
        $type = ">";
    } else {
        $self->error_record(__PACKAGE__." invalid type: $write_type", 3, $self->error);
    }

    $self->debug_record(__PACKAGE__." writing file: $write_file");
    open(FH, "$type $write_file") or $self->error_record(__PACKAGE__." can not open file: $write_file", 4, $self->error);
    print FH "$write_str";
    close(FH);

}

1;
