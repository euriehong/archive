#!/usr/bin/perl

use strict;

open (GOA, "gzcat gene_association.goa_uniprot.gz |") || die "Cannot open GOA file:$!\n";

while ( <GOA> ) {
    chomp;

    my $line = $_;

    my ( @c ) = split(/\t/, $line);

# Saccharomyces cerevisiae is taxon 4932
    if ( $c[12] eq "taxon:4932" ) {

# don't want annotations from SGD
	unless ( $c[14] eq "SGD" ) {

# don't want IEA annotations
	    unless ( $c[6] eq "IEA" ) {

# don't want annotations by IntAct using IPI evidence to protein binding (GO:0005515)
		unless ( $c[4] eq "GO:0005515" & $c[6] eq "IPI" & $c[14] eq "IntAct" ) {

# if we get here we want this annotation
		    print "$line\n";
		}
	    }
	}
    }
}

1;
