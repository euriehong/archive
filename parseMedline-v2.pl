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
my %vol = ();
my %issue = ();
my %date = ();
my %title = ();
my %page = ();
my %abstract = ();
my %author = ();
my %journal = ();
my %pmc = ();
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
	$pub{$pmid}=1;
#	print STDOUT "$pmid\n";
#	$pub{$pmid} = "euriehong";
#	print STDOUT "$pub{$pmid}\n";   
    }
    elsif ($count == 1 ) {
        if ($row[0] =~ /VI/) {
            $vol{$pmid} = "\"$row[1]\"";
#	    print STDOUT "$row[0]\n";
        }
        if ($row[0] =~ /IP/) {
            $issue{$pmid} = "\"$row[1]\"";
        }
	if ($row[0] =~ /DP/) {
	    $date{$pmid} = "\"$row[1]\"";
	}
	if ($row[0] =~ /TI/) {
	    $title{$pmid} = "$row[1]";
	    $count=2;
	}
	if ($row[0] =~ /PG/) {
	    $page{$pmid} = "\"$row[1]\"";
	}
	if ($row[0] =~ /AB/) {
	    $abstract{$pmid} = "$row[1]";
	    $count = 4;
	}
        if ( ($row[0] =~ /^AU/) && ($row[0] !~ /^AUID/) ) {
#	    $row[1] =~ s/ /,/;
            $author{$pmid} = "$row[1]";
            $count = 3;
        }
	if ($row[0] =~ /JT/) {
            $journal{$pmid} = "$row[1]";
        }
        if ($row[0] =~ /PMC$/) {
            $pmc{$pmid} = "$row[1]";
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
            $page{$pmid} = "\"$row[1]\"";
	    $count = 1;
        } elsif ( ($row[0] ne 'FAU') && ($row[0] ne 'CI') && ($row[0] ne 'AU') && ($row[0] ne 'LID') && ($row[0] ne 'AB') )  {
            $row[0] =~ s/^ +//;
#           print OUT "$row[0]\n";
	    $title{$pmid} .= " $row[0]";
        } elsif ($row[0] =~ /AB/) {
            $abstract{$pmid} = "$row[1]";
            $count = 4;
	} elsif ( ($row[0] =~ /^AU/) && ($row[0] !~ /^AUID/) ) {
#            $row[1] =~ s/ /,/;
	    $author{$pmid} = "$row[1]";
	    $count = 3;
	}
    }
    elsif ($count == 3 ) {
	if ( ($row[0] =~ /^AU/) && ($row[0] !~ /^AUID/) ){
#            $row[1] =~ s/ /,/;
 	    $author{$pmid} .= ", $row[1]";
	} elsif ($row[0] =~ /LA/) {
            $count = 1;
        }
    }

    elsif ($count == 4 ) {
	if ( ($row[0] ne 'AU') && ($row[0] ne 'AUID' ) && ($row[0] ne 'FAU') && ($row[0] ne 'CI') && ($row[0] ne 'CN') ){
	    $row[0] =~ s/^ +//;
	    $abstract{$pmid} .= " $row[0]";
	}
	if ( ($row[0] =~ /^AU/) && ($row[0] !~ /^AUID/) ) {
	    $author{$pmid} = "$row[1]";
	    $count = 3;
	}
    }

}

print OUT "PMID\tvolume\tissue\tdate\ttitle\tpage\tabstract\tauthor\tjournal\tidentifiers\n";

foreach my $x (keys %pub) {
    
    print OUT "$x\t";

    if (exists $vol{$x}) {
	print OUT "$vol{$x}\t";
    } else {
	print OUT "\t";
    } 
    
    if (exists $issue{$x}) {
	print OUT "$issue{$x}\t";
    } else {
	print OUT "\t";
    }
    
    if (exists $date{$x}) {
	print OUT "$date{$x}\t";
    } else {
	print OUT "\t";
    }
    
    if (exists $title{$x}) {
	$title{$x} =~ s/  / /g;
	print OUT "$title{$x}\t";
    } else {
	print OUT "\t";
    }
    
    if (exists $page{$x}) {
	print OUT "$page{$x}\t";
    } else {
	print OUT "\t";
    }
    
    if (exists $abstract{$x}) {
	$abstract{$x} =~ s/  / /g;
	print OUT "$abstract{$x}\t";
    } else {
	print OUT "\t";
    }
    
    if (exists $author{$x}) {
	print OUT "$author{$x}\t";
    } else {
	print OUT "\t";
    }
    
    if (exists $journal{$x}) {
	print OUT "$journal{$x}\t";
    } else {
	print OUT "\t";
    }
    
    if (exists $pmc{$x}) {
	print OUT "PMID:$x;PMCID:$pmc{$x}\n";
    } else {
	print OUT "PMID:$x\n";
    }







}


close IN;
close OUT;
