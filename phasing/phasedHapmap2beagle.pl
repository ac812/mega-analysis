#!/usr/bin/perl -w

use strict;

open (FILE, $ARGV[0]);
my @lines= <FILE>;

#print STDERR "Processing $file...\n";
my $i;
my $j;
my $pop = $ARGV[1];
my $markers = $pop."_markers.txt";
my $out= $pop."_phased.txt";
my $A=0;
my $C=0;
my $T=0;
my $G=0;
open (OUT, ">$out");
open (MARK, ">$markers");

	for $i (0 .. $#lines){
	    my @split= split(/\s+/, $lines[$i]);
	    if ($i==0){
		print OUT "I\tid";
		for $j (2 .. $#split){
		    print OUT "\t$split[$j]";
		}
		print OUT "\n";
		
	    }
	    my $count=0;
	    if ($i >0){
		for $j (0 .. $#split){
		    if ($j==1){
			next;
		    }
		    if ($split[$j] eq "A"){
			$A++;
			$count++;
		    }
		    if ($split[$j] eq "C"){
			$C++;
			$count++;
		    }
		    if ($split[$j] eq "T"){
			$T++;
			$count++;
		    }
		    if ($split[$j] eq "G"){
			$G++;
			$count++;
		    }

		  #  print OUT "\t$split[$j]";
		}
		my $checkA=0;
		my $checkC=0;
		my $checkT=0;
		my $checkG=0;
		my @alleles=();
		if ($A == $count){
		   # @alleles= ("NA", "NA", "NA", "A");
		    $A=0;
		    $C=0;
		    $T=0;
		    $G=0;
		    $count=0;
		    $checkA=0;
		    $checkC=0;
		    $checkT=0;
		    $checkG=0;
		    @alleles=();
		    next;
		}
		if ($C == $count){
		    #@alleles= ("NA", "NA", "NA", "C");
		    
		    $A=0;
		    $C=0;
		    $T=0;
		    $G=0;
		    $count=0;
		    $checkA=0;
		    $checkC=0;
		    $checkT=0;
		    $checkG=0;
		    @alleles=();
		    next;
		}
		if ($T == $count){
		    #@alleles= ("NA", "NA", "", "T");
		    $A=0;
		    $C=0;
		    $T=0;
		    $G=0;
		    $count=0;
		    $checkA=0;
		    $checkC=0;
		    $checkT=0;
		    $checkG=0;
		    @alleles=();		    
		    next;
		}
		if ($G == $count){
		    #@alleles= ("G", "G", "G", "G");
		    $A=0;
		    $C=0;
		    $T=0;
		    $G=0;
		    $count=0;
		    $checkA=0;
		    $checkC=0;
		    $checkT=0;
		    $checkG=0;
		    @alleles=();		 
		    next;
		}
		print MARK "$split[0]\t$split[1]";
		print OUT "M";
		for $j (0 .. $#split){
		    if ($j==1){
			next;
		    }
		    print OUT "\t$split[$j]";
		}
		
		@alleles= ($A, $C, $T, $G);
		#print STDERR "@alleles\n";
		@alleles= sort{$a <=> $b}(@alleles);
		#print STDERR "@alleles\n";
		#die;
	
		for $j (0 .. $#alleles){
		   
		    if ($alleles[$j] == $A and $checkA==0){
			$alleles[$j]= "A";
			$checkA=1;
			next;
		    }
		    if ($alleles[$j] == $C and $checkC==0){
			$alleles[$j]="C";
			$checkC=1;
			next;
		    }
		    if ($alleles[$j] == $G and $checkG==0){
			$alleles[$j]="G";
			$checkG=1;
			next;
		    }
		    if ($alleles[$j] == $T and $checkT==0){
			$alleles[$j]="T";
			$checkT=1;
			next;
		    }
		}
		#print STDERR "@alleles\n";
		print MARK "\t$alleles[3]\t$alleles[2]\n";
		$A=0;
		$C=0;
		$T=0;
		$G=0;
		$count=0;
		$checkA=0;
		$checkC=0;
		$checkT=0;
		$checkG=0;
		@alleles=();
		print OUT "\n";
	    }
}
close (OUT);
close (FILE);
close (MARK);
print STDERR "finished\n";
