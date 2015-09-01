#!/usr/bin/perl

use strict;

my $input = shift;
my $output = shift;

unless ( defined($input) && defined($output) ) {
    die "usage: split_many_to_one.pl [input] [output]\n";
}

open (IN, "$input") || die "Cannot open $input for reading: $!\n";
open (OUT, ">$output") || die "Cannot open $output for reading: $!\n";
#open (ID, ">ID-1.txt");

while (<IN>) {
    chomp;
    my (@data) = split(/\t/);

#    print OUT join("::", @data)."\n";

#    print ID "$data[1]\n";

    my (@values) = split(/;/, $data[1]);

    for (my $i= 0; $i < @values; $i++) {
	print OUT "$data[0]\t$values[$i]\n";

    }

}



close IN;
close OUT;
