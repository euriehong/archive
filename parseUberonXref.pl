#!/usr/bin/perl

use strict;

my $input = shift;
my $output = shift;

unless ( defined($input) && defined($output) ) {
    die "usage: parseMEDLINE.pl [uberon.obo flat file] [output]\n";
}

open (IN, "$input") || die "Cannot open $input for reading: $!\n";
open (OUT, ">$output") || die "Cannot open $output for reading: $!\n";
#open (ID, ">ID-1.txt");

my %xref = ();
my $uberon;
my $count=0;
my @row;

while (<IN>) {
    chomp;

    @row = split(/: /);

    if ( ($row[0] =~ /Term/) && ($count == 1) ) {
	$count = 0;
    }

#    print OUT "$row[0]\n";

    if ( ($row[0] =~ /id/) && ($count == 0) ) {
	$uberon = $row[1];
	$count = 1;
    }
    elsif ( ($row[0] =~ /xref/) && ($count == 1 ) && ($row[1] =~ /^MA:/) ) {
            $xref{$uberon} = "$row[1]";
#	    print STDOUT "$row[0]\n";
    }
}

foreach my $x (keys %xref) {
	print OUT "$x\t$xref{$x}\n";
}

close IN;
close OUT;
