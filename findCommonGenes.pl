#!/usr/bin/perl

# This script finds genes that are common to multiple files
# 
#
# 
#


use strict;

my $fileCount = @ARGV;

#print STDOUT "$fileCount\n";

if (  $fileCount == 0 ) {
    die "usage: findCommonGenes.pl [list of all files to compare] [\n";
}


my %geneCount = ();
my %geneData = ();

for my $name (<@ARGV>) {

    open (FILE, "$name") || die "Cannot open $name for reading: $!\n";

#    print STDOUT "$name\n";

    my %geneFile = ();

    while (<FILE>) {
	chomp;
	my (@data) = split(/\t/);

	my $gene = shift(@data);

	if (exists $geneData{$gene}) {
#	    $geneData{$gene} .= "\t$data[2]\t$data[3]\t$data[4]\t$data[5]";
	    $geneData{$gene} .= "\n$gene\t";
	    $geneData{$gene} .= join("\t", @data);
	    $geneFile{$gene}++;
	} else {
	    $geneData{$gene} = join("\t", @data);
	    $geneFile{$gene} = 1;
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

open (OUT, ">findCommonGenes-results.xls") || die "Cannnot open: $!\n";

foreach my $x (keys %geneCount) {

#    print STDOUT "$x\t$geneCount{$x}\n";

    if ( $geneCount{$x} >= $fileCount ) {
	print OUT "$x\t$geneData{$x}\n";
    }

}
