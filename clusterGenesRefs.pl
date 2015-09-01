#!/usr/bin/perl

use strict;

my $input = shift;
my $output = shift;

unless ( defined($input) && defined($output) ) {
    die "usage: clusterGenesRefs.pl [input] [output]\n";
}

my %cluster = ();
my $ref;

open (IN, "$input") || die "Cannot open $input for reading: $!\n";
open (OUT, ">$output") || die "Cannot open $output for reading: $!\n";
#open (ID, ">ID-1.txt");

while (<IN>) {
    chomp;
    my (@data) = split(/\t/);

    $ref = $data[0]."\t".$data[1];

#    print OUT join("::", @data)."\n";
#    print ID "$data[1]\n";

    if ( exists $cluster{$ref} ) {
	$cluster{$ref} .= "\t$data[2]";
    } else {
	$cluster{$ref} = $data[2];
    }

} 

foreach my $x (keys %cluster) {
    print OUT "$x\t$cluster{$x}\n";
}

close IN;
close OUT;
