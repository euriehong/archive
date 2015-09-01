#!/usr/bin/perl

use strict;

my @htmllist;

&dodir('.');

my $filecnt = 0;
my $chgcnthtml = 0;
my $chgcntgz = 0;

print "Found $#htmllist HTML files.\n";

foreach my $file (@htmllist) {
    my $line = "";

    ++$filecnt;

    open (FILE, $file) || die "cannot open for reading $file: $!\n";

    while (<FILE>) {
	$line .= $_;
    }
    close (FILE);

    my $line2 = &changeline($line);

    unless ($line eq $line2) {
	++$chgcnthtml;
	open (FILEOUT, ">$file.out") || die "cannot open for writting $file: $!\n";

	print FILEOUT "$line2";
	close (FILEOUT);
    }
    if ($filecnt % 100 == 0) {
	print STDERR "\r$filecnt\t$chgcnthtml";
    }
}

print "\r$filecnt\t$chgcnthtml\n";

1;

sub changeline {
    my $line = $_[0];

              #/share/bread/www-data/html/Saccharomyces/FullText/124/12455693//
    $line =~ s#/share/bread/www-data/html/Saccharomyces/FullText/\d\d\d/\d+//##g;

    return $line;
}

sub dodir {
    my ($dir,$nlink) = @_;
    my ($dev,$ino,$mode,$subcount);
    my @filenames;

    # At the top level, we need to find nlink ourselves.

    ($dev,$ino,$mode,$nlink) = stat('.') unless $nlink;

    # Get the list of files in the current directory.
    opendir(DIR,'.') || die "Can't open . for reading: $!";
    @filenames = readdir(DIR);
    closedir(DIR);

    if ($nlink == 2) { # This dir has no subdirectories.
	for (@filenames) {
	    next if $_ eq '.';
	    next if $_ eq '..';
	    next if -l $_;
	    if (($_ =~ /.html$/ && -f $_ && !(-l $_)) || ($_ =~ /.shtml$/ && -f $_ && !(-l $_)) || ($_ =~ /.pl$/ && -f $_ && !(-l $_)) || ($_ =~ /.pm$/ && -f $_ && !(-l $_)) ) {
		push (@htmllist, "$dir/$_");
	    }
	}
    }
    else { # This dir has subdirectories.
	$subcount = $nlink - 2;
	for (@filenames) {
	    next if $_ eq '.';
	    next if $_ eq '..';
	    next if -l $_;
	    if (($_ =~ /.html$/ && -f $_ && !(-l $_)) || ($_ =~ /.shtml$/ && -f $_ && !(-l $_)) || ($_ =~ /.pl$/ && -f $_ && !(-l $_)) || ($_ =~ /.pm$/ && -f $_ && !(-l $_))) {
		push (@htmllist, "$dir/$_");
	    }
	    next if $subcount == 0;  # Seen all the subdirs?

	    # Get link count and check for diretoriness.

	    ($dev,$ino,$mode,$nlink) = lstat($_);
	    next unless -d $_;

	    # It really is a directory, so do it recursively.

	    chdir $_ || die "Can't chdir to $_: $!";
	    &dodir("$dir/$_",$nlink);
	    chdir '..';
	    --$subcount;
	}
    }
}
