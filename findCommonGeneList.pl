#!/usr/bin/perl

# This script finds genes that are common to multiple files.  Outputs a list of genes.
#


use strict;

my $fileCount = @ARGV;

#print STDOUT "$fileCount\n";

if (  $fileCount == 0 ) {
    die "usage: findCommonGeneList.pl [list of all files to compare]\n";
}

my %geneCount = ();
my $gene;

for my $name (<@ARGV>) {

    open (FILE, "$name") || die "Cannot open $name for reading: $!\n";

#    print STDOUT "$name\n";

    my %geneFile = ();

    while (<FILE>) {
	chomp;
	my (@data) = split(/\t/);

	$gene = shift(@data);

#	$gene = "$data[0]\t$data[1]\t$data[2]";

	if (exists $geneFile{$gene}) {
	    $geneFile{$gene}++;
#	    print STDOUT "$name\t$gene\t$geneFile{$gene}\n";

	} else {
	    $geneFile{$gene} = 1;
#	    print STDOUT "$name\t$gene\t$geneFile{$gene}\n";
	}
	
    }

    foreach my $y (keys %geneFile)  {

#	print STDOUT "$y\t$geneFile{$y}\t$geneData{$y}\n";

	if (exists $geneCount{$y}) {
	    $geneCount{$y}++;
	} else {
	    $geneCount{$y} = 1;
	}
    }

}

open (OUT, ">findCommonGeneList-results.xls") || die "Cannnot open: $!\n";

foreach my $x (keys %geneCount) {

    print STDOUT "$x\t$geneCount{$x}\n";

    if ( $geneCount{$x} == $fileCount ) {
	print OUT "$x\t$geneCount{$x}\n";
    }

}
