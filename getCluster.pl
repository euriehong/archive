#!/usr/bin/perl

use strict;

my $input = shift;
my $output = shift;

unless ( defined($input) && defined($output) ) {
    die "usage: getCluster.pl [input] [output]\n";
}

my %cluster = ();
my %hits = ();

open (IN, "$input") || die "Cannot open $input for reading: $!\n";
open (OUT, ">$output") || die "Cannot open $output for reading: $!\n";
#open (ID, ">ID-1.txt");

while (<IN>) {
    chomp;
    my (@data) = split(/\|/);

#    print OUT join("::", @data)."\n";

    $data[1] =~ s/\..+//;

#    print ID "$data[1]\n";

    if (exists $cluster{$data[0]}) {
	$cluster{$data[0]} .= "::$data[1]";
	$hits{$data[0]} .= "::$data[2]";
    } else {
	$cluster{$data[0]} = $data[1];
	$hits{$data[0]} = $data[2];
    }

} 

foreach my $x (keys %hits) {
    if ( ($hits{$x} =~ /musculus/) && ($hits{$x} =~ /thaliana/) && ($hits{$x} =~ /cerevisiae/) ) {
	print OUT "$x\t$cluster{$x}\n";
    }
}

close IN;
close OUT;
