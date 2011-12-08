#!/usr/perl/bin -w


my $chr=0;
my $i;
my $j;
open (FILE, "<$ARGV[0]");
my @lines= <FILE>;
my @all= split(/\s+/, $lines[0]);
close (FILE);
my $dir;

for $chr ($ARGV[1] .. $ARGV[2]){
   #print STDERR "doing chromosome $chr...\n";
    for $i (0 .. $#all-1){
	my $group= $all[$i];
	my $file= "SplitPhased/".$group."_chr".$chr.".recode.phase.inp";
	my $clean= "MakeIHS/".$group."_chr".$chr.".recode.phase.inp_clean";
	system "sed '1,4d' $file  | sed 'n;n;d'| sed 'n;d' | sed 's/1/1 /g' | sed 's/0/0 /g' > $clean";
    }
}
