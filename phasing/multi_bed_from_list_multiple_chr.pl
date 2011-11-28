#!/usr/bin/perl -w
#lp8@sanger.ac.uk

use strict;
#$ARGV[4] is the column where the splitting label is
my $i;
my $j;
my $k;
my $last=0;
my @split;

open (LIST, "<$ARGV[0]");
my @lines= <LIST>;
chomp @lines;
my $chr=$ARGV[2];
open (POPS, ">pops_downstream.txt");
my $count=0;
for $k ($chr .. $ARGV[3]){
    $count =0;
    system "mkdir $k";
    #my $tobecut=  $k."_Genetic_Distances_and_ANCESTRAL_DAFs.txt";
    #my $aftercut= $k."_snplist.txt";
    #system "cut -f 2 $tobecut > $aftercut";
    
    for $i (0 .. $#lines){
	@split = split(/\s+/, $lines[$i]);
	my @splitnext = split (/\s+/, $lines[$i+1]);
	if (($split[$ARGV[4]] ne $splitnext[$ARGV[4]]) or ($i == $#lines)){
	    my $pop = $split[$ARGV[4]]."_chr".$k;
	    if ($ARGV[4] == 3 and $k == $ARGV[2]){
		print POPS "$split[$ARGV[4]]\t";
	    }
	    my $outfile= "$k/".$i.$pop."_temp.txt";
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
		system "plink --bfile $ARGV[1] --keep $outfile --chr $k --keep-allele-order --recode --alleleACGT --tab --out $k/$pop --noweb";
		if ($count ==0){
		    
		    system "plink --bfile $ARGV[1] --keep $outfile --chr $k --keep-allele-order --make-bed --out $k/tomarkers --noweb";
		    $count=1;
		}
	    }
	    if ($ARGV[4] == 3){
		system "plink --bfile $ARGV[1] --keep $outfile --chr $k --keep-allele-order --recode-fastphase --reference-allele ancestral_alleles.txt --out $k/$pop --noweb";
	    }
	    
	    
	    
	    #system "bsub -o $k/$log -P team19 'plink --bfile $ARGV[1] --keep $outfile --chr $k --hardy --out $k/$pop --noweb --reference-allele ~lp8/TOOMAS_SAFE/rs_ids_safe_snps_ANCESTRAL_STATE.txt'";
	    close (OUT);
	    
	}
	
    }
    $last=0;
    $i=0;
}
print POPS "\n";
close (POPS);
#system "rm *temp.txt *.nosex *.log";
close (LIST);
	

	











