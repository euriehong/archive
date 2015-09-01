#!/tools/perl/current/bin/perl -w

use strict;

my $dir = shift;
my $oldURL = "ftp://genome-ftp.stanford.edu/pub/yeast/";
my $newURL ="http://downloads.yeastgenome.org/"; 

my @file = `more $dir`;

foreach $html (@file) {

    chomp $html;

    open (PAGE, "$html") || die "Can't open '$html' for reading:$!\n";
    

    while (<PAGE>) {
	chomp;

	if (/$oldURL/) {
	    s/$oldURL/$newURL/g;
	}



    }

}
