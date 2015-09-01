#!/usr/bin/perl

use strict;

my $input = shift;
my $output = shift;

unless ( defined($input) && defined($output) ) {
    die "usage: sortByGene.pl [input] [output]\n";
}

open (IN, "$input") || die "Cannot open $input for reading: $!\n";
open (OUT, ">$output") || die "Cannot open $output for reading: $!\n";

while (<IN>) {
    chomp;
    my (@data) = split(/\;/);

    for (my $i= 1; $i < @data; $i++) {
	print OUT "$data[0]\t$data[$i]\n";
    }

}

close (IN);
close (OUT);

exit;
