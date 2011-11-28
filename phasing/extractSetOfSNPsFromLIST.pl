#!/usr/bin/perl -w
#argv0 = input file #argv1 = list of snps to be extracted (chr\tPosition)

use strict;

open (FILE, "<$ARGV[0]");
my @filelines = <FILE>;
chomp @filelines;

open (LIST, "<$ARGV[1]");
my @listlines = <LIST>;
chomp @listlines;

my $i;
my $j;
my $k=0;
my $m;
open (OUT, ">snps_to_keep.txt");
for $j (0 .. $#listlines){
    my @splitlist= split(/\s+/, $listlines[$j]);
    for ($i=$k;$i<=$#filelines; $i++){
	my @splitfile = split(/\s+/, $filelines[$i]);
	if ($splitfile[0] eq $splitlist[0] and $splitfile[3] eq $splitlist[3]){
	    #print "$splitlist[1]\t$splitfile[0]";
	    print OUT "$splitfile[1]\n";
	    #for $m (1 .. $#splitfile){
		#print OUT "\t$splitfile[$m]";
	    #}
	    #"\n";
	    #print "$splitfile[0]\t$splitfile[1]\t$splitfile[2]\t$splitfile[3]\n";
	    #print STDERR "found!$j\n";
	    $k=$i;
	    last;
	}
	#if ($splitfile[0] eq $splitlist[0] and $splitfile[1] < $splitlist[3]){
	 #   last;
	#}
	if ($splitfile[0] > $splitlist[0] or ($splitfile[0] eq $splitlist[0] and $splitfile[3] > $splitlist[3])){# eq 'X' or $splitfile[1] eq 'M' or $splitfile[1] eq 'Y'){
	    #print STDERR "$splitlist[3]\t$splitfile[1]\n";
	   # die;
	    #print "$splitlist[0]\t$splitlist[1]\t$splitlist[3]\tNA\n";
	    last;
	}
    }
}
#system "cut -f 2 mergedmapLUCA.txt > snps_to_keep.txt";
#system "rm mergedmapLUCA.txt";

close ( FILE );
close ( LIST );
print STDERR "finished\n";

	
	    
