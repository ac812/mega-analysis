import os
import sys
import ConfigParser as config

if len(sys.argv)!=2:
    print "python %s POP" % (sys.argv[0],)
    print "POP is YRI or CEU"
    print "Will do ALL chromosomes"
    sys.exit(-1)

cfg = config.ConfigParser()
cfg.read(os.path.expanduser("~/.megacfg"))
scriptDir = cfg.get("System", "scriptDir")


pop = sys.argv[1]
href = "hapmap3_r2_b36_fwd.consensus.qc.poly.chr"
rlist = open("reflist.txt", "w")
os.system("gzip -d %s*gz 2>/dev/null" % (href,))
for chi in range(22): #add 1
    ch = chi + 1
    print "chr %d" % (ch,)
    if ch >1:
        mapf = "%s%d_%s.phased.map" % (href, ch, pop.lower())
        pedf = "%s%d_%s.phased.ped" % (href, ch, pop.lower())
        rlist.write("%s\t%s\n" % (pedf, mapf))
    phased = "%s%d_%s.phased" % (href, ch, pop.lower())

    os.system("perl %s/make_cheated_plink.pl %s hapmap_phased %d" %
              (scriptDir, phased, ch))
rlist.close()
prefix = "%s%d_%s.phased" % (href, 1, pop.lower())
os.system("plink --file %s --merge-list reflist.txt --make-bed --out REF%s --noweb" % (prefix, pop))
os.remove("reflist.txt")
os.system("rm -f %s*ped 2>/dev/null" % (href,))
os.system("rm -f %s*map 2>/dev/null" % (href,))
os.system("gzip %s* 2>/dev/null" % (href,))
