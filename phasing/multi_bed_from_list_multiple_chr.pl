#!/usr/bin/perl -w
#lp8@sanger.ac.uk

use strict;
#$ARGV[4] is the column where the splitting label is
#$ARGV[5] is the output directory
my $i;
my $j;
my $k;
my $last=0;
my @split;

my $outDir=$ARGV[5];

open (LIST, "<$ARGV[0]");
my @lines= <LIST>;
chomp @lines;
my $chr=$ARGV[2];
open (POPS, ">$outDir/pops_downstream.txt");
my $count=0;
for $k ($chr .. $ARGV[3]){
    $count =0;
    
    for $i (0 .. $#lines){
	@split = split(/\s+/, $lines[$i]);
	my @splitnext = split (/\s+/, $lines[$i+1]);
	if (($split[$ARGV[4]] ne $splitnext[$ARGV[4]]) or ($i == $#lines)){
	    my $pop = $split[$ARGV[4]]."_chr".$k;
	    if ($ARGV[4] == 3 and $k == $ARGV[2]){
		print POPS "$split[$ARGV[4]]\t";
	    }
	    my $outfile= "$outDir/${k}_".$i.$pop."_temp.txt";
	    print STDERR "$outfile";
	    #die;
	    open (OUT, ">$outfile");
	    for $j ($last .. $i){
		@split = split(/\s+/, $lines[$j]);
		print OUT "$split[0]\t$split[1]\n";
	    }
	    $last=$i+1;
	    my $log=$pop.".farmput";
	   #my $extract= $aftercut; #$k."_Genetic_Distances_and_ANCESTRAL_DAFs.txt";
	    if ($ARGV[4] == 2){
		system "plink --bfile $ARGV[1] --keep $outfile --chr $k --keep-allele-order --recode --alleleACGT --tab --out $outDir/$pop --noweb";
		if ($count ==0){
		    
		    system "plink --bfile $ARGV[1] --keep $outfile --chr $k --keep-allele-order --make-bed --out $outDir/${k}_tomarkers --noweb";
		    $count=1;
		}
	    }
	    if ($ARGV[4] == 3){
		system "plink --bfile $ARGV[1] --keep $outfile --chr $k --keep-allele-order --recode-fastphase --reference-allele ancestral_alleles.txt --out $outDir/$pop --noweb";
	    }
	    close (OUT);
	}
    }
    $last=0;
    $i=0;
}
print POPS "\n";
close (POPS);
close (LIST);
