#!/usr/bin/perl -w
#lp8@sanger.ac.uk

use strict;
use camExecute;

my $i;
my $j;
my $k;
my $last=0;
my @split;

#open (LIST, "<$ARGV[0]");
#my @lines= <LIST>;
#chomp @lines;
my $chr=$ARGV[0];

#open (MARKERS, ">22markers.txt");
my $log;
my $out;
my $inp;
my $known;
my $ped;
my $map;
my $bgl;
my $pedtrios;
my $maptrios;
my $bgltrios;
my $markers;
my $phased;
my $unphased;
my $outbeagle;
my $logbeagle;
my $tosubst;
my $substed;
my $tprefix;
my $tlog;
for $k ($chr .. $ARGV[1]){
    if ($ARGV[2] eq "AFRO"){
	$log=$k."_afro".$k.".farmput";
	$tlog="afro".$k.".farmput";
	$out=$k."/AFRO_phase".$k;
	$inp=$k."/AFRICAN_chr".$k.".recode.phase.inp";
	$known=$k."/YRItrios_chr".$k."_knownHaplotypes.txt";
	$ped=$k."/AFRO_chr".$k.".ped";
	$map=$k."/AFRO_chr".$k.".map";
	$bgl=$k."/AFRO_chr".$k.".bgl";
	$pedtrios=$k."/AFROtrios_chr".$k.".ped";
	$maptrios=$k."/AFROtrios_chr".$k.".map";
	$bgltrios=$k."/AFROtrios_chr".$k.".bgl";
	$markers=$k."/markers_chr".$k.".txt";
	$phased= $k."/YRItrios_chr".$k.".bgl";
	$unphased=$k."/AFRICAN_chr".$k.".bgl";
	$outbeagle=$k."/phasedAFRO_chr".$k.".bgl";
	$logbeagle= $k."/beagleafro".$k.".farmput";
	$tosubst=$k."/AFRO_phase".$k."_hapguess_switch.out.ped";
	$substed=$k."/temp.txt";
	$tprefix=$k."/phasedAFRO_chr".$k.".bgl.AFRICAN_chr".$k.".bgl.phased.gz";
    }
    if ($ARGV[2] eq "OOA"){
	$log=$k."/ooa".$k.".farmput";
	$tlog="ooa".$k.".farmput";
	$out=$k."/OOA_phase".$k;
	$inp=$k."/OOA_chr".$k.".recode.phase.inp";
	$known=$k."/CEUtrios_chr".$k."_knownHaplotypes.txt";
	$ped=$k."_OOA_chr".$k.".ped";
	$map=$k."_OOA_chr".$k.".map";
	$bgl=$k."_OOA_chr".$k.".bgl";
	$pedtrios=$k."_OOAtrios_chr".$k.".ped";
	$maptrios=$k."_OOAtrios_chr".$k.".map";
	$bgltrios=$k."_OOAtrios_chr".$k.".bgl";
	$markers=$k."/markers_chr".$k.".txt";
	$phased= $k."/CEUtrios_chr".$k.".bgl";
	$unphased=$k."/OOA_chr".$k.".bgl";
	$outbeagle=$k."/phasedOOA_chr".$k.".bgl";
	$logbeagle= $k."/beagleooa".$k.".farmput";
	$tprefix=$k."/phasedOOA_chr".$k.".bgl.OOA_chr".$k.".bgl.phased.gz";
    }
    #system "bsub -P team19 -o $tlog 'plink --tfile $tprefix --keep-allele-order --recode --tab --noweb --out $tprefix'"#transpose tped into bed
    if ($ARGV[3] eq "Ped2Beagle"){
	system "ped_to_bgl SplitUnphased/$ped SplitUnphased/$map > Ped2Beagle/$bgl"; #get ped into beagle format
	system "ped_to_bgl SplitUnphased/$pedtrios SplitUnphased/$maptrios > Ped2Beagle/$bgltrios"; #get ped into beagle format
    }
    if ($ARGV[3] eq "Markers"){
	system "cut -f 2,4,5,6 $k/tomarkers.bim > $k/markers_chr$k.txt"; #get testbim files into beagle markers file
	system "rm $k/tomarkers.*";
    }
}
