#!/usr/bin/perl

use strict;

my $input = shift;
my $output = shift;


unless ( defined($input) && defined($output) ) {
    die "usage: getAnnotIntersection.pl [input] [output]\n";
}

my %type = ();
my %hits = ();

open (IN, "$input") || die "Cannot open $input for reading: $!\n";
open (ALL, ">$output"."-all.txt") || die "Cannot open $output for reading: $!\n";
open (CC, ">$output"."-CC.txt") || die;
open (SINGLE, ">$output"."-single.txt") || die;
open (COMPH, ">$output"."-CompH.txt") || die;
open (COREH, ">$output"."-CoreH.txt") || die;

while (<IN>) {
    chomp;
    my (@data) = split(/\t/);

#    print OUT "$data[7]\n";

    if (exists $type{$data[1]}) {
	if ($type{$data[1]} =~ /$data[7]/) {
	    next;
	} else {
	    $type{$data[1]} .= "::$data[7]";
	    $hits{$data[1]} ++;
	}
    } else {
	$type{$data[1]} = $data[7];
	$hits{$data[1]} = 1;
    }
}

foreach my $x (keys %type) {
    if ( $hits{$x} == 3) {
#&& ($type{$x} =~ /computational/) && ($type{$x} =~ /throughput/) && ($type{$x} =~ /core/) ) 
	print ALL "$x\t$type{$x}\n";
    } elsif ($hits{$x} == 2) {
	if ( ($type{$x} =~ /computational/) && ($type{$x} =~ /throughput/) ) {
	    print COMPH "$x\t$type{$x}\n";
	} elsif ( ($type{$x} =~ /core/) && ($type{$x} =~ /throughput/) ) {
	    print COREH "$x\t$type{$x}\n";
	} elsif ( ($type{$x} =~ /computational/) && ($type{$x} =~ /core/) ) {
	    print CC "$x\t$type{$x}\n";
	}
    } elsif ($hits{$x} == 1) {
	print SINGLE "$x\t$type{$x}\n";
    }
}

close IN;
close ALL;
