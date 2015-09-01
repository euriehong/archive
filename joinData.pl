#!/usr/bin/perl

# This script appends data in multiple files to the end of a row in the original file.  The original file can contain
# many rows.  The files that contain information to append should contain the same identifier in the first column.
# subsequent columns should contain the data to append.
# 
# The first column of the set of files must contain the unique identifier for the gene.
# 
# Does not remove whitespace and returns that may be present at the end of the line in the original files.
#


use strict;

#my $count = @ARGV;

my $results = shift(@ARGV);
my $input = shift(@ARGV);
my $fileCount = @ARGV;
#my $fileCount = $count-2;

print STDOUT "$fileCount\n";

unless (defined($results) && defined($input) && ($fileCount>=0) ) {
    die "usage: findGeneSet-generic.pl [results file] [original file to append data] [all files containing data to append]\n";
}

#my %geneCount = ();
my %geneData = ();


open (OUT, ">$results".".xls") || die;
open (IN, "$input") || die "Cannot open $input for reading: $!\n";


#foreach my $u (keys %uniprotData) {
#    print STDOUT "$u\t$uniprotData{$u}\n";
#}

for my $name (<@ARGV>) {

    open (FILE, "$name") || die "Cannot open $name for reading: $!\n";

    while (<FILE>) {
	chomp;
	my (@data) = split(/\t/);

#	my $ignore = shift(@data);
	my $gene = shift(@data);

	if (exists $geneData{$gene}) {
	    $geneData{$gene} .= join("\t", @data);
	} else {
	    $geneData{$gene} = join("\t", @data);
	}
    }
}


while (<IN>) {

#    chomp;

    $_ =~ s/\n//;
    
    my (@row) = split(/\t/);
    
#    my $feature = shift(@row);
    my $feature = $row[1];

    if (exists $geneData{$feature}) {
	print OUT "$_\t$geneData{$feature}\n";
    } else {
	print OUT "$_\tNo data\n";
    }

}


