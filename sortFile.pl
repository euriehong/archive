#!/tools/perl/current/bin/perl

use strict;

my $inFile = shift;
my $outDir = shift;
my $line;

unless ( defined($inFile) && defined($outDir) ) {
    die "usage: sortFile.pl input_file output_directory\n";
}

my @CHR = ('chrI', 'chrII', 'chrIII', 'chrIV', 'chrV', 'chrVI', 'chrVII',
	   'chrVIII', 'chrIX', 'chrX', 'chrXI', 'chrXII', 'chrXIII', 'chrXIV', 
	   'chrXV', 'chrXVI');

foreach my $chromosome (@CHR) {

    open (IN, "$inFile") || die "Cannot open $inFile for reading: $!\n";
    open (OUT, ">$outDir/$inFile-$chromosome") || die "Cannot open $inFile-$chromosome for reading: $!\n";

    print OUT "chr\tstart\tstop\tstrand\tscore\tfeature\n";

    while (defined ($line = <IN>)) {
	if ($line =~ m/^$chromosome\s/) {
	    print OUT "$line";
	}
    }

}
