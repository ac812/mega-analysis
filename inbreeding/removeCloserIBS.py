import os
import sys

#THIS IS NOT USED AND WRONG!!!!

if len(sys.argv)!=3:
    print "python %s pop cloThres" % (sys.argv[0],)
    sys.exit(-1)

pop = sys.argv[1]
cloThres = float(sys.argv[2])

allInds = []
hasCloser = True

fName = "%s_lst.txt" % (pop,)
f = open(fName)
for l in f:
    allInds.append(l.rstrip().split(" "))
f.close()

def genKeepList(pop, lst):
    fKeep = "%s_keep.txt" % (pop,)
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

genKeepList(pop, allInds)

currentInds = {}
for ind in allInds:
    currentInds[ind[0]] = [ind[1], ind[2]]

while hasCloser:
    os.system("nice -n19 plink --bfile %s --keep %s_keep.txt --noweb --out %s_keep --make-bed >/dev/null" % (pop, pop, pop))
    os.system("nice -n19 plink --bfile %s_keep --genome --maf 0.01 --noweb --min %f --out %s_keep > /dev/null" % (pop, cloThres, pop))
    f = open("%s_keep.genome" % (pop,))
    f.readline() #header
    indClo = {}
    for cl in f:
        toks = filter(lambda x: x!="", cl.rstrip().split(" "))
        for ind in [toks[0], toks[2]]:
            indClo[ind] = indClo.get(ind, 0) + 1
    f.close()
    minRep = 0
    for bad in indClo:
        if indClo[bad]>minRep:
            minRep = indClo[bad]
    for bad in indClo:
        if indClo[bad]==minRep:
            print bad, minRep, indClo, len(allInds), len(currentInds)
            del currentInds[bad]
            genKeepList(pop, getPlinkFormat(currentInds))
            break # We remove just one and retry
    hasCloser = indClo.keys() != []

