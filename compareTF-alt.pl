#!/usr/bin/perl

use strict;

my $sgdTF = shift;
my $otherTF = shift;
my $output = shift;

unless ( defined($sgdTF) && defined($otherTF) && defined($output) ) {
    die "usage: compareTF.pl SGD_TF_file Other_TF_file output_file\n";
}

my ($sgdCHR, $sgdSTART, $sgdNAME, $sgdSTOP, $sgdSTRAND, $otherSTRAND, $otherCHR, $otherSTART, $otherSTOP,$otherNAME, $key, $key2);
my $sgdSOURCE = "Publication";
my $sgdTYPE = "TF_binding_site";
my $noMATCH = "TF-nomatch.lst";
my %hits = ();

open (SGD, "$sgdTF") || die "Cannot open $sgdTF for reading: $!\n";
open (OTHER, "$otherTF") || die "Cannot open $otherTF for reading: $!\n";
open (OUT, ">$output") || die "Cannot open $output for writing: $!\n";
open (NONE, ">$noMATCH") || die "Cannot open $noMATCH for writing: $!\n";


while (<SGD>)  {
    chomp;
    my (@sgdcol) = split(/\t/);

    $sgdCHR = $sgdcol[0];
    $sgdSTART = $sgdcol[3];
    $sgdSTOP = $sgdcol[4];
    $sgdSTRAND = $sgdcol[6];
    my @NAME = split (/site/, $sgdcol[8]); 
    $sgdNAME = $NAME[0];

    $key = "$sgdNAME:$sgdCHR:$sgdSTART";
    $hits{$key} = 0;
#    print "$key\n";


    while (<OTHER>) {
	chomp;
#	print "$key:$_\n";

	my (@othercol) = split(/\t/);

	$otherCHR = $othercol[0];
	$otherSTART = $othercol[3];
	$otherSTOP = $othercol[4];
	$otherSTRAND = $othercol[6];
	my @oNAME = split (/site/, $othercol[8]);
	$otherNAME = $oNAME[0];

#	print "$otherNAME\n";

	if (($sgdCHR eq $otherCHR) && (($sgdSTART - 20) < $otherSTART) && ($otherSTART < ($sgdSTART + 20)) && ($sgdNAME eq $otherNAME)) {
	    print OUT "$sgdCHR..$otherCHR\t$sgdSOURCE\t$sgdTYPE\t$sgdSTART..$otherSTART\t$sgdSTOP..$otherSTOP\t.\t$sgdSTRAND..$otherSTRAND\t.\t$sgdcol[8];SEQ=$othercol[8]\n";
	    $key2 = "$otherNAME:$otherCHR:$sgdSTART";
	    $hits{$key2}++;
	    print "$key2\n";
#	    print "$sgdCHR:$sgdSTART:$sgdcol[8]\n";
#	    print "$otherCHR:$otherSTART:$othercol[8]\n";
	    last;
	} 
    }
}

foreach my $y (keys %hits) {
  if ( $hits{$y} == 0 ){
      print NONE "$y\n";
    }
}

exit;
