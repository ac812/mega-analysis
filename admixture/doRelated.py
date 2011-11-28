import os
import sys

if len(sys.argv)!=4:
    print "python %s plinkFile OP cloThres" % (sys.argv[0],)
    print "OP is split, IBS, IBD, statIBD, removeCloser"
    sys.exit(-1)

plink = sys.argv[1]
OP = sys.argv[2]
cloThres = float(sys.argv[3])

pops = {}
for l in sys.stdin:
    toks = l.rstrip().split(" ")
    pops.setdefault(toks[2], []).append([toks[0], toks[1]])



if OP == "split":
    for pop in pops:
        fName ="%s_lst.txt" % (pop,)
        f = open(fName, "w")
        for indiv in pops:
            f.write(" ".join(indivs))
            f.write(" " + pop)
            f.write("\n")
        f.close()
        os.system("nice -n19 plink --bfile %s --keep %s --noweb --out %s &" % (plink, fName, pop))
elif OP == "IBS":
    for pop in pops:
        os.system("nice -n19 plink --bfile %s --cluster --neighbour 1 5 --noweb --out %s &" % (pop, pop))
elif OP == "IBD":
    for pop in pops:
        os.system("nice -n19 plink --bfile %s --genome --noweb --min %f --out %s &" % (pop, cloThres, pop))
elif OP == "statIBD":
    for pop in pops:
        f = open("%s.genome" % (pop))
        f.readline()
        vals = []
        for l in f:
            pihat = float(filter(lambda x: x!="", l.rstrip().split(" "))[9])
            vals.append(pihat)
        vals.sort()
        print "%12s" % (pop,), "%.3f " % (sum(vals)/len(vals),), "%.3f " % (vals[len(vals)/2],), len(vals)
        f.close()
elif OP == "removeCloser":
    for pop in pops:
        os.system("nice -n19 pyhon removeCloser.py %s %f &" % (pop, cloThres))

