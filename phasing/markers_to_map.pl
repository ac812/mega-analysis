#!/usr/bin/perl -w

#unzip beagle outputs chromosomewise and generate fake plinks within each chr folder

my $k;
my $i;
my $j;
my @phased;
my $ped;
my @matrix;
for $k ($ARGV[0] .. $ARGV[1]){
    print STDERR "dealing with chromosome $k...\n";
    @phased= glob ("$k/*hapguess_switch.out");
#("$k/*phased.gz");
    foreach my $file (@phased){
	print STDERR "file is $file...\n";
	my $map= $file.".map";
	my $markers= "../BEAGLE/".$k."/markers_chr".$k.".txt";
	#system "gzip $file -d -c > unzipped.txt";
	open (FILE, "<$markers");
	my @lines= <FILE>;
	chomp @lines;
#	open (PED, ">$ped");
	open (MAP, ">$map");
	for $i (0 .. $#lines){
	    my @split= split(/\s+/, $lines[$i]);
	    print MAP "$k\t$split[0]\t0\t$split[1]\n";
	}
	close (MAP);
	close (FILE);
    }
}

print STDERR "finished\n";
			
