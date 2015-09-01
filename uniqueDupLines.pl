#!  /usr/bin/perl -w
# note for me: put into util/curator/
################################################################################
# Script name: uniqueDupLines.pl
# Author: Karen Christie,
#      based heavily on a script by Kara Dolinski that compared two files and
#      wrote lines that were unique in the first to a file
# Description: compares two files, writes lines that are unique to the
#      first input file to one output file and that are identical in
#      both input files to a second output file
# Usage: uniqueDupLines.pl
# Script will ask for:
#      1. first file name
#      2. second file name
# Output will be in two files:
#      1. uni.txt will contain lines that are unique in the first file
#      2. dup.text will contain lines that are identical in both files
# writing out unique lines
################################################################################

# getting the file name;
print ("Enter file name 1: ");
chomp ($input1=<STDIN>);

print ("Enter file name 2: ");
chomp ($input2=<STDIN>);


# opening the files
open (ONE, "< $input1") or die;

open (UNI, "> uni.txt") or die;

open (DUP, "> dup.txt") or die;

#####################################################
# want to read in a line from the ONE file,   
# and compare it to all the lines in the TWO file  
# 
# If the line from ONE  does not exist in the TWO file, 
# then I want to write it to the UNI file.  
# 
# If the line from ONE does exist in the TWO file,
# then I want to write it to the DUP file.
#######################################################

while ($ONE=<ONE>) {
    
  chomp ($ONE);
  open (TWO, "< $input2") or die;
  $dupct = 0;
  
  while ($TWO=<TWO>) {
    
    chomp ($TWO);
    
    if ($ONE eq $TWO) {
        
        $dupct = $dupct +1;
	print DUP ("$ONE\n");
	last;
    } 
  }
    
# the idea here is that if the line in the ONE file  
# issn't in the TWO file, then the 
# $dupct = 0, so the line won't be printed to UNI

  if ($dupct == 0) {
      print UNI ("$ONE\n");
  }  

  close (TWO);

}

close (ONE);
close (UNI);
close (DUP);

__END__


