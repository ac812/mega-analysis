#!/usr/bin/perl -w
#lp8@sanger.ac.uk

use strict;

my $i;
my $j;
my $k;
my $last=0;
my @split;

open (LIST, "<$ARGV[0]");
my @lines= <LIST>;
chomp @lines;

for $i (0 .. $#lines){
    @split = split(/\s+/, $lines[$i]);
    my @splitnext = split (/\s+/, $lines[$i+1]);
    if (($split[2] ne $splitnext[2]) or ($i == $#lines)){
	my $pop = $split[2]."_chr".$ARGV[1];
	my $outfile= $i."_chr".$ARGV[1]."_temp.txt";
	open (OUT, ">$outfile");
	for $j ($last .. $i){
	    @split = split(/\s+/, $lines[$j]);
	    print OUT "$split[0]\t$split[1]\n";
	}
	$last=$i+1;
	system "bsub -o plink.farmput -P team19 'plink --bfile newBILLpopsLIST --keep $outfile --extract ~/22markers.txt --make-bed --out $pop --noweb'";
	close (OUT);
    }
}
#system "rm *temp.txt *.nosex *.log";
close (LIST);
	

	











