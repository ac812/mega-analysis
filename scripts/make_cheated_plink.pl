#!/usr/bin/perl -w

use strict;

my $i;
my $j;
my $k;
my @A=();
my @B=();
my @lines=();
my @split=();
my $sampleA;
my $sampleB;
my @geno=();



# FROM PLINK to CHEATED PLINK

#argv0= input ped
#arg1= "plink_to_cheated";
#argv2= output ped

if ($ARGV[1] eq "plink_to_cheated"){
    open (FILE, "<$ARGV[0]");
    @lines=<FILE>;
    chomp @lines;
    open (OUT, ">$ARGV[2]");
	  for $i (0 .. $#lines){
	      @split= split(/\t/, $lines[$i]);
	      $A[0]=$split[0]."_A";
	      $B[0]=$split[0]."_B";
	      $A[1]=$split[1]."_A";
	      $B[1]=$split[1]."_B";

	      for $j (2 .. 5){
		  $A[$j]=$split[$j];
		  $B[$j]=$split[$j];
	      }
	      for $j (6 .. $#split){
		  @geno= split(/\s/, $split[$j]);
		  $A[$j]= $geno[0]." ".$geno[0];
		  $B[$j]= $geno[1]." ".$geno[1];
	      }
	      print OUT "$A[0]";
	      for $k (1 .. $#A){
		  print OUT "\t$A[$k]";
	      }
	      print OUT "\n$B[0]";
	      for $k (1 .. $#B){
		  print OUT "\t$B[$k]";
	      }
	      print OUT "\n";
	      

	  }
    close (OUT);
    close (FILE);

}

#FROM HAPMAP PHASED TO CHEATED PLINK
#ARGV[0]=input file;
#ARGV[1]="hapmap_phased";
#ARGV[2]= "chr number";
if($ARGV[1] eq "hapmap_phased"){

    my $ped= $ARGV[0].".ped";
    my $map= $ARGV[0].".map";
    open (FILE, "<$ARGV[0]");
    @lines=<FILE>;
    chomp @lines;
    
    open (PED, ">$ped");
    open (MAP, ">$map");

    for $i (0 .. $#lines){
	@split=split(/\s+/, $lines[$i]);

	if ($i ==0 ){
	    for $j (2 .. $#split){
		$A[$i][$j-2]=$split[$j];
	    }
	    next;
	}
	
	if ($i > 0){
	    print MAP "$ARGV[2]\t$split[0]\t0\t$split[1]\n";
	    for $j (2 .. $#split){
		$A[$i][$j-2]=$split[$j]." ".$split[$j];
	    }
	}
    }
    close (MAP);
    
    for $i (0 .. ($#split-2)){
	print PED "$A[0][$i]\t$A[0][$i]\t0\t0\t1\t-9";
	for $j (1 .. $#lines){
	    print PED "\t$A[$j][$i]";
	}
	print PED "\n";
    }
    close (FILE);
    close(PED);
}
