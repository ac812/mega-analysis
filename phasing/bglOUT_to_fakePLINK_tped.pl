#!/usr/bin/perl -w

#unzip beagle outputs chromosomewise and generate fake plinks within each chr folder

my $k;
my $i;
my $j;
my @phased;
my $ped;
my @matrix;
my $first;
open (OUT, ">MergePhased/phased_files.txt");

for $k ($ARGV[0] .. $ARGV[1]){
    my $markers= "SplitUnphased/OOAtrios_chr".$k.".map"; 
    my $toglob= "phased".$ARGV[2]."_chr".$k.".bgl.gz.".$ARGV[2]."_chr".$k.".bgl.gz.phased.gz"; #be careful to exclude trios!
    #print STDERR "dealing with chromosome $k...\n";
    chdir "Beagle";
    @phased= glob ("$toglob");
    chdir "..";
    foreach my $file (@phased){
	#print STDERR "file is $file...\n";
	$ped= "MergePhased/".$file.".tempped";
	my $fam= "MergePhased/".$file.".tfam";
	#system "gzip Beagle/$file -d -c > MergePhased/unzipped.txt";
	#open (FILE, "<MergePhased/unzipped.txt");
	open (FILE, "-|", "zcat Beagle/$file");
	my @lines= <FILE>;
	chomp @lines;
	open (PED, ">$ped");
	open (FAM, ">$fam");
	for $i (1 .. $#lines){
	    my @split= split(/\s+/, $lines[$i]);
	    for $j (2 .. $#split){
		if ($i == 1){
		    if ( $j%2==1){
			print FAM "$split[$j]_B\t$split[$j]_B\t0\t0\t1\t1\n";
		    }
		    else{
			print FAM "$split[$j]_A\t$split[$j]_A\t0\t0\t1\t1\n";
		    }
		    
		}
		else{
		    print PED "$split[$j] $split[$j]\t";
		}
	    }
	    if ($i >1){
		print PED "\n";
	    }
	    @split=();
	}
	#for $j (0 .. $#matrix){
	 #   for $i (0 .. $#lines-1){
		#print OUT "$matrix[$j][$i]\t";
	    #}
	    #print OUT "\n";
	#}
	close (PED);
	close (FAM);
	@matrix=();
	@lines=();
	#@split=();
	
	my $final= $file.".tped";
	system "paste $markers $ped > MergePhased/$final";
	my $out= "MergePhased/".$k.$ARGV[2]."phased";
	system "plink --tfile MergePhased/$file --recode --alleleACGT --noweb --out $out";
	my $ped= $out.".ped";
	my $map= $out.".map";
	if ($k==$ARGV[0]){
	    $first=$out;
	}
	if ($k > $ARGV[0]){
	    print OUT "$ped\t$map\n";
	}
    }
}
close (OUT);
system "plink --file $first --merge-list MergePhased/phased_files.txt --make-bed --out MergePhased/GENO_PHASED --noweb";
