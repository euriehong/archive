#!/usr/bin/perl

# This script gets any information from a set of files for any list of genes 
# 
# The first column of the set of files must contain the unique identifier for the gene.
# The list of genes entered into the script but be the same unique identifier.
# 
# Does not remove whitespace and returns that may be present at the end of the line in the original files.
#


use strict;

#my $count = @ARGV;

my $results = shift(@ARGV);
my $list = shift(@ARGV);
my $fileCount = @ARGV;
#my $fileCount = $count-2;

print STDOUT "$fileCount\n";

unless (defined($results) && defined($list) && ($fileCount>=0) ) {
    die "usage: findGeneSet-generic.pl [results file] [list of genes] [all files to search]\n";
}

#my %geneCount = ();
my %geneData = ();


open (OUT, ">$results".".tsv") || die;
open (IN, "$list") || die "Cannot open $list for reading: $!\n";


#foreach my $u (keys %uniprotData) {
#    print STDOUT "$u\t$uniprotData{$u}\n";
#}

for my $name (<@ARGV>) {

    open (FILE, "$name") || die "Cannot open $name for reading: $!\n";

    while (<FILE>) {
#	chomp;
	my (@data) = split(/\t/);

#	my $ignore = shift(@data);
	my $gene = shift(@data);

	if (exists $geneData{$gene}) {
	    $geneData{$gene} .= "\n$gene\t";	    
	    $geneData{$gene} .= join("\t", @data);
	} else {
	    $geneData{$gene} = join("\t", @data);
	}
    }
}


while (<IN>) {
    chomp;

    if (exists $geneData{$_}) {
	print OUT "$_\t$geneData{$_}";
    } else {
	print OUT "$_\tNo data\n";
    }

}


