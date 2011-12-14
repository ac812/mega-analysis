import sys
import os
import shutil
import subprocess
import MEGA

if len(sys.argv) not in [1,2]:
    print "python %s [bundle]" % (sys.argv[0],)
    print "Needs statIBD.txt"
    sys.exit(-1)

if len(sys.argv)==2:
    bundle = sys.argv[1]
else:
    bundle = None

def doPop(pop, rest, bf):
    try:
        os.mkdir(os.sep.join([MEGA.cacheDB, "pops"]))
    except OSError:
        pass #Already exists, OK
    popDir = os.sep.join([MEGA.cacheDB, "pops", pop])
    try:
        os.mkdir(popDir)
    except OSError:
        pass #Already exists, OK
    w = open(popDir + os.sep + "statIBD", "w")
    w.write(rest+"\n")
    if bf:
        bf.write(pop+"\t"+rest+"\n")
    w.close()

def startBundle(bundle):
    try:
        os.mkdir(os.sep.join([MEGA.cacheDB, "bundles"]))
    except OSError:
        pass #Already exists, OK
    bundleDir = os.sep.join([MEGA.cacheDB, "bundles", bundle])
    try:
        os.mkdir(bundleDir)
    except OSError:
        pass #Already exists, OK
    bw = open(bundleDir + os.sep + "statIBD", "w")
    return bw

sf = open("statIBD.txt")

pops = []
if bundle:
    bf = startBundle(bundle)
else:
    bf = None
for l in sf:
    toks = l.rstrip().split("\t")
    pop = toks[0].rstrip().lstrip()
    doPop(pop, "\t".join(toks[1:]), bf)
    pops.append(pop)

def doPopDistant(pop):
    popDir = os.sep.join([MEGA.cacheDB, "pops", pop])
    shutil.copyfile("ibdata" + os.sep + pop + "_distant.txt",
                popDir + os.sep + "distant")

def doPopClose(pop):
    popDir = os.sep.join([MEGA.cacheDB, "pops", pop])
    f = open("ibdata" + os.sep + pop + "_ibd.fam")
    lenf= len(f.readlines())
    w = open(popDir + os.sep + "close", "w")
    w.write(str(lenf))
    w.write("\n")
    f.close()
    w.close()

for pop in pops:
    doPopDistant(pop)
    doPopClose(pop)
