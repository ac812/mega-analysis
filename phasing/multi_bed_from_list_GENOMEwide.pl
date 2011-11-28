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
	my $pop = $split[2];
	my $outfile= $i."_temp.txt";
	open (OUT, ">$outfile");
	for $j ($last .. $i){
	    @split = split(/\s+/, $lines[$j]);
	    print OUT "$split[0]\t$split[1]\n";
	}
	$last=$i+1;
	my $out= $pop;#."_NEAND";
	my $log= $pop."_log.farmput";
	#system "bsub -o $log -P team19 'plink --bfile $ARGV[1] --keep $outfile --extract $ARGV[2] --reference-allele ~lp8/TOOMAS_SAFE/rs_ids_safe_snps_ANCESTRAL_STATE.txt --freq --out $out --noweb'";
	system "bsub -o $log -P team19 'plink --file $ARGV[1] --keep $outfile --extract $ARGV[2] --hardy --out $out --noweb'";
	close (OUT);
    }
}
#system "rm *temp.txt *.nosex *.log";
close (LIST);
	


	











