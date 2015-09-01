#!/usr/bin/perl

use strict;

my $inFile = shift;
my $outFile = shift;

unless ( defined($inFile) && defined($outFile) ) {
    die "usage: reformatBrow.pl input_file output_file\n";
}


open (IN, "$inFile") || die "Cannot open $inFile for reading: $!\n";
open (OUT, ">$outFile") || die "Cannot open $outFile for writing: $!\n";

my $count  = 1;
my $chr;

while (<IN>) {
    chomp;
    if (/reference/) {
	my (@ref) = split(/=/);
	$chr = $ref[1];
    } else {
	my (@row) = split;
	print OUT "$chr\t$row[2]\tW\t$row[3]\tPMID-wt-$count\n";
	$count ++;
    }

}
