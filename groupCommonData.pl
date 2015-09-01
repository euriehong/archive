#!/usr/bin/perl

# This script groups data common to the identifiers in the first column.  Multiple files can be piped 
# in as long as they all have the first column contain the same identifier.
#

use strict;

my $results = shift(@ARGV);
my $fileCount = @ARGV;

unless (defined($results) && ($fileCount>=0) ) {
    die "usage: groupCommonData.pl [results file] [all files to search]\n";
}


my %data = ();

open (OUT, ">$results".".txt") || die;

for my $name (<@ARGV>) {

    open (FILE, "$name") || die "Cannot open $name for reading: $!\n";

    while (<FILE>) {

	chomp;
	my (@row) = split(/\t/);

	if (exists $data{$row[0]}) {
	    if ($data{$row[0]} =~ /$row[1]/) {
		next;
	    } else {
		$data{$row[0]} .= "\t$row[1]";
	    }
	} else {
	    $data{$row[0]} = "$row[1]";
	}

    }
}

foreach my $gene (keys %data) {

    print OUT "$gene\t$data{$gene}\n";

}

