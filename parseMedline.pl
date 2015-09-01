#!/usr/bin/perl

use strict;

my $input = shift;
my $output = shift;

unless ( defined($input) && defined($output) ) {
    die "usage: parseMEDLINE.pl [MEDLINE flat file] [output]\n";
}

open (IN, "$input") || die "Cannot open $input for reading: $!\n";
open (OUT, ">$output") || die "Cannot open $output for reading: $!\n";
#open (ID, ">ID-1.txt");

my %pub = ();
my $pmid;
my $count=0;
my @row;

while (<IN>) {
    chomp;

    @row = split(/ - |- |  - /);

#    print OUT "$row[0]\n";

    if ( ($row[0] =~ /PMID/) && ($count == 0) ) {
	$pmid = $row[1];
	$count = 1;
#	print STDOUT "$pmid\n";
#	$pub{$pmid} = "euriehong";
#	print STDOUT "$pub{$pmid}\n";   
    }
    elsif ($count == 1 ) {
        if ($row[0] =~ /VI/) {
            $pub{$pmid} = "\"$row[1]\"";
#	    print STDOUT "$row[0]\n";
        }
        if ($row[0] =~ /IP/) {
            $pub{$pmid} .= "\t\"$row[1]\"";
        }
	if ($row[0] =~ /DP/) {
	    $pub{$pmid} .= "\t\"$row[1]\"";
	}
	if ($row[0] =~ /TI/) {
	    $pub{$pmid} .= "\t$row[1]";
	    $count=2;
	}
	if ($row[0] =~ /PG/) {
	    $pub{$pmid} .= "\t\"$row[1]\"";
	}
	if ($row[0] =~ /AB/) {
	    $pub{$pmid} .= "\t$row[1]";
	    $count = 2;
	}
        if ( ($row[0] =~ /^AU/) && ($row[0] !~ /^AUID/) ) {
#	    $row[1] =~ s/ /,/;
            $pub{$pmid} .= "\t$row[1]";
            $count = 3;
        }
	if ($row[0] =~ /JT/) {
            $pub{$pmid} .= "\t$row[1]";
        }
        if ($row[0] =~ /PMC$/) {
            $pub{$pmid} .= "\t$row[1]";
        }
        if ($row[0] =~ /SO/) {
	    $count = 0;
        }
    }
    elsif ($count == 2 ) {
#	if ( ($row[0] ne 'FAU') && ($row[0] ne 'CI') )  {
#	    $row[0] =~ s/^ +//;
#	    print OUT "$row[0]\n";
#	    $pub{$pmid} .= " $row[0]";
#	}
        if ($row[0] =~ /PG/) {
            $pub{$pmid} .= "\t\"$row[1]\"";
	    $count = 1;
        } elsif ( ($row[0] ne 'FAU') && ($row[0] ne 'CI') && ($row[0] ne 'AU') )  {
            $row[0] =~ s/^ +//;
#           print OUT "$row[0]\n";
	    $pub{$pmid} .= " $row[0]";
        }

	if ( ($row[0] =~ /^AU/) && ($row[0] !~ /^AUID/) ) {
#            $row[1] =~ s/ /,/;
	    $pub{$pmid} .= "\t$row[1]";
	    $count = 3;
	}
    }
    elsif ($count == 3 ) {
	if ( ($row[0] =~ /^AU/) && ($row[0] !~ /^AUID/) ){
#            $row[1] =~ s/ /,/;
 	    $pub{$pmid} .= ", $row[1]";
	}
        if ($row[0] =~ /LA/) {
            $count = 1;
        }
    }

}

foreach my $x (keys %pub) {
	print OUT "$x\t$pub{$x}\n";
}


close IN;
close OUT;
