import os
import sys

if len(sys.argv)!=2:
    print "python %s pop" % (sys.argv[0],)
    sys.exit(-1)

pop = sys.argv[1]

allInds = []

fName = "ibdata/%s_lst.txt" % (pop,)
f = open(fName)
for l in f:
    allInds.append(l.rstrip().split(" "))
f.close()

def genList(pop, lst):
    fKeep = "ibdata/%s_distant.txt" % (pop,)
    f = open(fKeep, "w")
    for i in lst:
        f.write(" ".join(i))
        f.write("\n")
    f.close()

def getPlinkFormat(pdict):
    inds = []
    for i in pdict:
        inds.append([i] + pdict[i])
    return inds

genList(pop, allInds)

currentInds = {}
for ind in allInds:
    currentInds[ind[0]] = [ind[1], ind[2]]

os.system("nice -n19 plink --bfile ibdata/%s --keep ibdata/%s_distant.txt --noweb --out ibdata/%s_distant --make-bed >/dev/null" % (pop, pop, pop))
os.system("nice -n19 plink --bfile ibdata/%s_distant --genome --maf 0.01 --noweb --min %f --out ibdata/%s_distant> /dev/null" % (pop, 0.0, pop))
f = open("ibdata/%s_distant.genome" % (pop,))
f.readline() #header
indClo = {}
for cl in f:
    toks = filter(lambda x: x!="", cl.rstrip().split(" "))
    for ind in [toks[0], toks[2]]:
        indClo.setdefault(ind, []).append(float(toks[6]))
f.close()
rems = {}
for ind in indClo:
    lst = indClo[ind]
    if sum(lst)==len(lst):
        rems[ind] = currentInds[ind]
genList(pop, getPlinkFormat(rems))
