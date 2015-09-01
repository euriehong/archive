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
    my (@data) = split(/\t/);

    my (@genes) = split(/\|/,$data[4]);

    for (my $i= 0; $i < @genes; $i++) {
	print OUT "$data[0]\t$data[3]\t$genes[$i]\n";
    }

}

close (IN);
close (OUT);

exit;
