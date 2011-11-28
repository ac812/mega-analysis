#!/usr/perl/bin -w

#YOU CAN COPY AND PASTE THE BLOCK BELOW MULTIPLE TIMES INTO THE SAME SCRIPT SO THAT IT WILL SEQUENTIALLY GENERATE ALL INPUT YOU'RE INTERESTED IN.
#copy from here...

my $chr=0;
system "mkdir IHS_input";
my $i;
my $j;
open (FILE, "<$ARGV[0]");
my @lines= <FILE>;
my @all= split(/\s+/, $lines[0]);
close (FILE);
my $dir;
#foreach my $thing (@all){
#    $dir= "IHS_input/".$1;
#from now on only "move output option";
#    if ($ARGV[0] eq "cp_output"){
	#system "mkdir $dir";
	#my $copy= "IHS_input/iHSput/*/*".$1."*put.txt";
	#my $paste= "IHS_input/".$1;
	#system "cp $copy $paste"; #just for moving outputs (downstream)
    #}
    
#}

#if ($ARGV[0] eq "cp_outputXPEHH"){
 #   mkdir "/XPEHH_paper/";
 #   for $i (0 .. $#all){
	#for $j (1 .. $#all){
	 #   if (($all[$i] eq "ANDREA1" and $all[$j] eq "ANDREA3") or ($all[$i] eq "ANDREA4" and $all[$j] eq "ANDREA7") or ($all[$i] eq "ANDREA7" and $all[$j] eq "ANDREA9") or ($all[$i] eq "ANDREA3" and $all[$j] eq "ANDREA5")){ #temporary filter
		#my $prefix=$all[$i]."_".$all[$j];
		#$dir= "../XPEHH_paper/".$prefix;
		#system "mkdir $dir";
		#my $copy= "IHS_input/XPEHHput/*/*".$prefix."*put.txt";
		#my $paste= "../XPEHH_paper/".$prefix;
		#system "cp $copy $paste"; #just for moving outputs (downstream)
	    #}
	#}
    #}
#}
#if ($ARGV[0] eq "cp_output" or $ARGV[0] eq "cp_outputXPEHH"){
    
 #   die; # use only with moving outputs option
#}

print STDERR "we are working on @all , aren't we?\n";
#die;


for $chr ($ARGV[1] .. $ARGV[2]){
    print STDERR "doing chromosome $chr...\n";
   # my @all= (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
    for $i (0 .. $#all-1){
	my $group= $all[$i];
	my $file= $chr."/".$group."_chr".$chr.".recode.phase.inp";
	my $clean= "IHS_input/".$group."_chr".$chr.".recode.phase.inp_clean";
	system "sed '1,4d' $file  | sed 'n;n;d'| sed 'n;d' | sed 's/1/1 /g' | sed 's/0/0 /g' > $clean";
    }
}
print STDERR "finished\n";
#rm -f [desired file name]${chr}.recode.phase.inp
#done

#until here
