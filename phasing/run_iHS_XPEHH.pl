#!/usr/bin/perl -w

#for each chromosome (1 .. 22) it either run iHS on each population or runs XPEHH on unique pariwises.

my $i;
my $k;
my $j;
my $out;
my $inmap;
my $log;
open (FILE, "<$ARGV[2]");
my @lines= <FILE>;
my @pops= split(/\s+/, $lines[0]);
close (FILE);

open(XSUB, ">myxsub");

if ($ARGV[0] eq "iHS"){
    for $k ($ARGV[3] .. $ARGV[4]){
	for $i (0 .. $#pops){
	    my $input="MakeIHS/".$pops[$i]."_chr".$k.".recode.phase.inp_clean";
	    $inmap="../MAPS/".$k.$ARGV[1];
	    $out= $ARGV[0]."/".$k.$pops[$i]."_chr".$k."_iHSput.txt";
	    $log= $ARGV[0]."/".$k.$pops[$i]."_chr".$k."_iHSlog.farmput";
	    print XSUB "ihs  $inmap $input#$inmap $input#$out\n";
	}
    }
}

if ($ARGV[0] eq "XPEHH"){
    open (FILE, "<$ARGV[5]");
    @lines= <FILE>;
    chomp @lines;
    for $i (0 .. $#lines){
	my @split= split (/\s+/, $lines[$i]);
	for $k ($ARGV[3] .. $ARGV[4]){
	    my $input1="MakeIHS/".$split[0]."_chr".$k.".recode.phase.inp_clean";
	    my $input2="MakeIHS/".$split[1]."_chr".$k.".recode.phase.inp_clean";
	    $inmap="../MAPS/".$k.$ARGV[1];
	    $out= $ARGV[0]."/".$k.$split[0]."_".$split[1]."_chr".$k."_XPEHHput.txt";
	    $log= $ARGV[0]."/".$k.$split[0]."_".$split[1]."_chr".$k."_XPEHHlog.farmput";
	    print XSUB "xpehh -m $inmap -h $input1 $input2#$inmap $input1 $input2#$out\n";
	}
    }    
    close (FILE);
}

close(XSUB);

