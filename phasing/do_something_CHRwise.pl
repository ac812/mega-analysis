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
	$log="afro".$k.".farmput";
	$tlog="afro".$k.".farmput";
	$out="AFRO_phase".$k;
	$inp="AFRICAN_chr".$k.".recode.phase.inp";
	$known="YRItrios_chr".$k."_knownHaplotypes.txt";
	$ped="AFRO_chr".$k.".ped";
	$map="AFRO_chr".$k.".map";
	$bgl="AFRO_chr".$k.".bgl";
	$pedtrios="AFROtrios_chr".$k.".ped";
	$maptrios="AFROtrios_chr".$k.".map";
	$bgltrios="AFROtrios_chr".$k.".bgl";
	$markers="markers_chr".$k.".txt";
	$phased= "YRItrios_chr".$k.".bgl";
	$unphased="AFRICAN_chr".$k.".bgl";
	$outbeagle="phasedAFRO_chr".$k.".bgl";
	$logbeagle= "beagleafro".$k.".farmput";
	$tosubst="AFRO_phase".$k."_hapguess_switch.out.ped";
	$substed="temp.txt";
	$tprefix="phasedAFRO_chr".$k.".bgl.AFRICAN_chr".$k.".bgl.phased.gz";
    }
    if ($ARGV[2] eq "OOA"){
	$log="ooa".$k.".farmput";
	$tlog="ooa".$k.".farmput";
	$out="OOA_phase".$k;
	$inp="OOA_chr".$k.".recode.phase.inp";
	$known="CEUtrios_chr".$k."_knownHaplotypes.txt";
	$ped="OOA_chr".$k.".ped";
	$map="OOA_chr".$k.".map";
	$bgl="OOA_chr".$k.".bgl";
	$pedtrios="OOAtrios_chr".$k.".ped";
	$maptrios="OOAtrios_chr".$k.".map";
	$bgltrios="OOAtrios_chr".$k.".bgl";
	$markers="markers_chr".$k.".txt";
	$phased= $k."/CEUtrios_chr".$k.".bgl";
	$unphased=$k."/OOA_chr".$k.".bgl";
	$outbeagle=$k."/phasedOOA_chr".$k.".bgl";
	$logbeagle= $k."/beagleooa".$k.".farmput";
	$tprefix="phasedOOA_chr".$k.".bgl.OOA_chr".$k.".bgl.phased.gz";
    }
    if ($ARGV[3] eq "Ped2Beagle"){
	system "ped_to_bgl SplitUnphased/$ped SplitUnphased/$map > Ped2Beagle/$bgl"; #get ped into beagle format
	system "ped_to_bgl SplitUnphased/$pedtrios SplitUnphased/$maptrios > Ped2Beagle/$bgltrios"; #get ped into beagle format
    }
    if ($ARGV[3] eq "Markers"){
	system "cut -f 2,4,5,6 SplitUnphased/${k}_tomarkers.bim > Ped2Beagle/markers_chr$k.txt"; #get testbim files into beagle markers file
	system "rm SplitUnphased/${k}_tomarkers.*";
    }
}
