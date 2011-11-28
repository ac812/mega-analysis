#!/usr/bin/perl -w

use strict;

##input file is a chr TAB rsID list (argv0);

##system "sort -n -k 1 $ARGV[0] > tempSORTED.txt";

open (FILE, "<$ARGV[0]");
my $i;
my @lines= <FILE>;

my $checkfileopen= 0;

for ( $i =0; $i <= $#lines; $i ++){
    my @split= split (/\s+/, $lines[$i]);
    my @splitprev= split (/\s+/, $lines[$i-1]);
    my @splitnext= split (/\s+/, $lines[$i+1]);
    if ($checkfileopen==0){
	my $outfile = $split[1]."_genetic_ancestral.txt"; #"_Genetic_Distances_and_ANCESTRAL_DAFs_ARIGUR_CEU.txt";
	open (OUT, ">$outfile");
##	print OUT "CHR\tRS\tPOS\tcM\tAFRICA\tEUROPE\tASIA\n";
	print STDERR "processing $outfile...\n";
	$checkfileopen=1;
    }
    if ($split[1] eq $splitnext[1]){
	#if ($i ==0){
	 #   print OUT "$lines[$i]";
	 #   print OUT "$split[0] $split[2] $split[3] $split[4] $split[5]\n";
	#}
	print OUT "$split[0] $split[2] $split[3] $split[4] $split[5]\n";
	#print OUT "$lines[$i]";
	##print OUT "$split[1]\n";
    }
    else {
	print OUT "$split[0] $split[2] $split[3] $split[4] $split[5]\n";
	#print OUT "$lines[$i]";
	##print OUT "$split[1]\n";
	$checkfileopen=0;
	close (OUT);
    }
}
##system "rm tempSORTED.txt";
print STDERR "FINISHED\n";
	
