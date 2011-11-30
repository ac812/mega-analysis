#!/usr/bin/perl -w
#argv0 = input file #argv1 = list of snps to be extracted (chr\tPosition)

use strict;

system "cut -f 2 $ARGV[0] | egrep '^rs' | cut -d 's' -f 2 | sort -n -k 1 > LP_A";
system "cut -f 2 $ARGV[1] | egrep '^rs' | cut -d 's' -f 2 | sort -n -k 1 > LP_B";

$ARGV[0]=~ m/(\w+)\.bim/g;
my $file1= $1;
$ARGV[1]=~ m/(\w+)\.bim/g;
my $file2= $1;

open (FILE, "<LP_A");
my @filelines = <FILE>;

open (LIST, "<LP_B");
my @listlines = <LIST>;

my $i;
my $j;
my $k=0;
my $m;
my @splitlist;
my @splitfile;
my @filenext;
my @fileprev;
my @listnext;
my @listprev;

open (OUT, ">snps_temp.txt");

for $j (0 .. $#listlines){
    @splitlist= split(/\n/, $listlines[$j]);
    for ($i=$k;$i<=$#filelines; $i++){
	@splitfile = split(/\n/, $filelines[$i]);
	if ($splitfile[0] eq $splitlist[0]){
	    print OUT "rs$splitfile[0]\n";
	    $k=$i;
	    last;
	}
	if ($splitfile[0] > $splitlist[0]){# eq 'X' or $splitfile[1] eq 'M' or $splitfile[1] eq 'Y'){
	    last;
	}
    }
}


close (FILE);
close (LIST);
close (OUT);

system "plink --bfile $file1 --extract snps_temp.txt --make-bed --out REFoverlap --noweb ";
system "plink --bfile $file2 --extract snps_temp.txt --make-bed --out GENOoverlap --noweb ";
system "rm LP_B LP_A snps_temp.txt";
#print STDERR "done with finding overlap, now attempting the hard task!\n";

my $check=0;
$i=1;
my $here=0;
while ($check==0){
   
    
    if ($i == 1){
	open (FILE, "<REFoverlap.bim");
	@filelines = <FILE>;
	
	open (LIST, "<GENOoverlap.bim");
	@listlines = <LIST>;
	open (A, ">TEMPsnps.txt");
    }
    if ($i >1 and $i == $#filelines+1 and $here==1){
	$i=1;
	$here=0;
	close (FILE);
	close (LIST);
	close (A);
	system "plink --bfile $file1 --extract TEMPsnps.txt --make-bed --out REFoverlap --noweb ";
	system "plink --bfile $file2 --extract TEMPsnps.txt --make-bed --out GENOoverlap --noweb ";
	system "cut -f 1-3 REFoverlap.bim > temp1.txt";
	system "cut -f 4,5,6 GENOoverlap.bim > temp2.txt";
	system "paste temp1.txt temp2.txt > REFoverlap.bim";
	system "rm temp1.txt temp2.txt";
	last;
    }
    if ($i == $#filelines+1 and $here==0){
	#system "rm TEMPsnps.txt";
	$check=1;
	system "cut -f 1-3 REFoverlap.bim > temp1.txt";
	system "cut -f 4,5,6 GENOoverlap.bim > temp2.txt";
	system "paste temp1.txt temp2.txt > REFoverlap.bim";
	system "rm temp1.txt temp2.txt";
	last;
    }
  
    
    $k=0;
    @listprev=split(/\s+/, $listlines[$i-1]);
    @splitlist= split(/\s+/, $listlines[$i]);
    #@listnext= split(/\s+/, $listlines[$i+1]);
    @fileprev= split(/\s+/, $filelines[$i-1]);
    @splitfile = split(/\s+/, $filelines[$i]);
    #@filenext= split(/\s+/, $filelines[$i+1]);
    if ($i < $#filelines){
	@listnext= split(/\s+/, $listlines[$i+1]);
	@filenext= split(/\s+/, $filelines[$i+1]);
    }

    if ($i ==1 ){
	print A "$listprev[1]\n";
    }
    if ($splitfile[1] eq $splitlist[1]){

	print A "$splitfile[1]\n";
	$i++;
    }
    else{

	$k=$i;
	$here=1; #make sure this makes sense
	my $check2=0;
	if ($splitfile[1] eq $listprev[1] or $splitfile[1] eq $listnext[1]){ #i.e. at the clash, the snp in file proves to be the right one
	   
	    while ($check2==0){
		#print STDERR "$k\t";
		#$check2=1; #delete this
		@splitlist= split(/\s+/, $listlines[$k]);
		@splitfile = split(/\s+/, $filelines[$k]);
		@listnext= split(/\s+/, $listlines[$k+1]);
		@filenext= split(/\s+/, $filelines[$k+1]);
		if ($filenext[1] eq $listnext[1]){ #unless the next position is the normal scenario is resotred (we are at the end of the messy block)
		    $check2=1;
		    last;
		}
		print A "$splitfile[1]\n"; #take note of the snps in the right list;
		$k++;
	    }
	}
	if ($splitlist[1] eq $fileprev[1] or $splitlist[1] eq $filenext[1]){
	   
	    while ($check2==0){
	
		@splitlist= split(/\s+/, $listlines[$k]);
		@splitfile = split(/\s+/, $filelines[$k]);
		@listnext= split(/\s+/, $listlines[$k+1]);
		@filenext= split(/\s+/, $filelines[$k+1]);
		if ($filenext[1] eq $listnext[1]){
		    $check2=1;
		    last;
		}
		print A "$splitlist[1]\n";
		$k++;
	    }
	}
	$check2=0;
	$i=$k+1;
    }
}
system "rm TEMPsnps.txt";
