#!/usr/bin/perl

############################################################################
#  Script: makePrimerGFF.pl
#  Author: Eurie
#  Description: creates a GFF3 file from the mapped results from findoligo.pl  
#    and the same primer input file
#    
#    columns of the findoligo.pl output file are
#        1.  primer sequence name
#        2.  primer sequence
#        3.  chromosome
#        4.  complement
#        5.  start_coord
#        6.  stop_coord
#    columns of the primer input file are
#        1.  primer pair name
#        2.  SGDID
#        3.  forward primer name
#        4.  forward primer sequence
#        5.  reverse primer name
#        6.  reverse primer sequence
############################################################################


use strict;
use DBI;
use lib qw (.);
use lib qw (/share/wine/www-data_sgd/lib);
use Tools::Question qw( ask ask_yes_no);

my $primerFile = shift;
my $mappedFile = shift;

if ((! defined $primerFile) || (! defined $mappedFile)) {
    print "Usage : makePrimerGFF.pl [File of primer pairs] [File of mapped primers] \n";
    exit;
}

##########################################################
#### main program
##########################################################
open (PRIMER, "<$primerFile") or die;
open (MAPPED, "<$mappedFile") or die;
open (GFF, ">resgen_primers.gff") or die;

my %primerCount = ();
my %primerMapping = ();
my @mapped;
my @results;
my @otherHits;
my ($id, $multiHits, $length, $forSeq, $forChr, $forStrand, $forStart, $forStop, $revSeq, $revChr, $revStrand, $revStart, $revStop, $i, $hit, $length, $j, $forSeq2, $forChr2, $forStrand2, $forStart2, $forStop2, $revSeq2, $revChr2, $revStrand2, $revStart2, $revStop2);
my $source = 'ResGen';
my $product1 = 'PCR_product';
my $product2 = 'primer';

# This loads the final mapped file, the output of the findOligo.pl
# program

while (<MAPPED>) {
    chomp;
    ($id, @mapped) = split (/\t/);
    if (exists $primerCount{$id}) {
	$primerCount{$id} ++;
	$multiHits = join("\t", @mapped);
	$primerMapping{$id} .= ":$multiHits";
    } else {
	$primerCount{$id} = 1;
	$primerMapping{$id} = join("\t", @mapped);
    }
}


# checking to make sure the hash works
# my $pNAME;
# my $count;
# while (($pNAME, $count) = each(%primerCount)) {
#     print GFF "the primer $pNAME has $count row(s)\n";
# }

# This loads the primer pairs and then finds the results from the
# earlier file that was inputted.

print GFF "##gff-version\t3\n";

while (<PRIMER>) {
    chomp;
    my (@pairs) = split (/\t/);


    if ($primerCount{$pairs[2]} == 1) {

	($forSeq, $forChr, $forStrand, $forStart, $forStop) = split (/\t/, $primerMapping{$pairs[2]}); 
	print GFF "$forChr\t$source\t$product2\t$forStart\t$forStop\t.\t.\t.\tID=$pairs[2];Name=$pairs[2];Sequence=$forSeq;Note=Unique%20hit;\n";

    }

    else {

	(@results) = split (/:/, $primerMapping{$pairs[2]});

	for ($i=0; $i < $primerCount{$pairs[2]}; $i++) {
	    $hit = shift(@results);
	    ($forSeq, $forChr, $forStrand, $forStart, $forStop) = split (/\t/, $hit);
	    print GFF "$forChr\t$source\t$product2\t$forStart\t$forStop\t.\t.\t.\tID=$pairs[2]"."-$i;Name=$pairs[2];Sequence=$forSeq;Note=Not%20a%20unique%20hit;Total_hit_count=$primerCount{$pairs[2]};Other_hit_coordinates=";
	    $length = @results;
	    for ($j=0; $j < $length; $j++) {
		($forSeq2, $forChr2, $forStrand2, $forStart2, $forStop2) = split (/\t/, $results[$j]);
		print GFF "$forChr2:$forStart2..$forStop2";
		if ($j != $length - 1) {
		    print GFF ",";
		}
	    }
	    push(@results, $hit);
	    print GFF ";\n";
	}

    }

    if  ($primerCount{$pairs[4]} == 1) {

	($revSeq, $revChr, $revStrand, $revStart, $revStop) = split (/\t/, $primerMapping{$pairs[4]}); 
	print GFF "$revChr\t$source\t$product2\t$revStart\t$revStop\t.\t.\t.\tID=$pairs[4];Name=$pairs[4];Sequence=$revSeq;Note=Unique%20hit;\n";

    }

    else {

	(@results) = split (/:/, $primerMapping{$pairs[4]});
	
	for ($i=0; $i < $primerCount{$pairs[4]}; $i++) {
	    $hit = shift(@results);
	    ($revSeq, $revChr, $revStrand, $revStart, $revStop) = split (/\t/, $hit);

	    print GFF "$revChr\t$source\t$product2\t$revStart\t$revStop\t.\t.\t.\tID=$pairs[4]"."-$i;Name=$pairs[4];Sequence=$revSeq;Note=Not%20a%20unique%20hit;Total_hit_count=$primerCount{$pairs[4]};Other_hit_coordinates=";
	    $length = @results;
	    for ($j=0; $j < $length; $j++) {
		($revSeq2, $revChr2, $revStrand2, $revStart2, $revStop2) = split (/\t/, $results[$j]);
		print GFF "$revChr2:$revStart2..$revStop2";
		if ($j != $length -1) {
		    print GFF ",";
		}
	    }
	    push(@results, $hit);
	    print GFF ";\n";
	}
	
    }
    
    if (($primerCount{$pairs[2]} == 1) && ($primerCount{$pairs[4]} == 1)) {

	if (($forStrand eq 'REV') && ($revStrand eq 'FOR')) {
	    $length = ($forStop - $revStart) + 1;
	    print GFF "$forChr\t$source\t$product1\t$revStart\t$forStop\t.\t.\t.\tID=$pairs[0]"."-product;Name=$pairs[0]-product;Note=product%20length%20is%20$length%20nt;\n";
	} 
	elsif (($forStrand eq 'FOR') && ($revStrand eq 'REV')) {
	    $length = ($revStop - $forStart) + 1;
	    print GFF "$forChr\t$source\t$product1\t$forStart\t$revStop\t.\t.\t.\tID=$pairs[0]"."-product;Name=$pairs[0]-product;Note=product%20length%20is%20$length%20nt;\n";
	}

    }

    

}


close (PRIMER);
close (MAPPED);
close (GFF);

exit;
