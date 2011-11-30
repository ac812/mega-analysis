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
scriptDir = cfg.get("System", "scriptsDir")


pop = sys.argv[1]
href = XXX
rlist = open("reflist.txt", "w")

for chi in range(22): #add 1
    ch = chi + 1

    if ch >1:
        mapf = "%s%d_%s.phased.map"  (href, ch, pop.lower())
        pedf = "%s%d_%s.phased.ped"  (href, ch, pop.lower())
        rlist.write("%s\t%s\n" % (mapf, pedf))
    phased = "%s%d_%s.phased" % (href, ch, pop.lower())

    os.system("perl %s/make_cheated_plink.pl %s hapmap_phased %d" %
              (scriptDir, phased, ch))
rlist.close()
prefix = "%s%d_%s.phased" % (href, 1, pop.lower())
os.system("plink --file %s --merge-list reflist.txt --make-bed --outREF%s --noweb" % (prefix, pop))
os.remove("reflist.txt")
