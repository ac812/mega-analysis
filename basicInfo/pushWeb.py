import sys
import os
import subprocess
import MEGA

if len(sys.argv)!=2:
    print "python %s pop" % (sys.argv[0],)
    sys.exit(-1)

pop=sys.argv[1]

myPathLst = __file__.split(os.sep)[:-1]

if len(myPathLst)==0:
    myPath = "doCounts.py"
else:
    myPath = os.sep.join(myPathLst + ["doCounts.py"])
    

p = subprocess.Popen("python " +  myPath + " " + pop,
                     shell=True, stdin=subprocess.PIPE,
                     stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                     close_fds=True)
lines = p.stdout.readlines()

def doPop(pop, size, indivs):
    if size==0: return #nothing
    try:
        os.mkdir(os.sep.join([MEGA.cacheDB, "pops"]))
    except OSError:
        pass #Already exists, OK
    popDir = os.sep.join([MEGA.cacheDB, "pops", pop])
    try:
        os.mkdir(popDir)
    except OSError:
        pass #Already exists, OK
    w = open(popDir + os.sep + "basic", "w")
    w.write(str(size) + "\n")
    w.close()
    w = open(popDir + os.sep + "indivs", "w")
    w.write("\n".join(map(lambda x:str(x), indivs)) + "\n")
    w.close()


def doBundle(bundle, pops, sizes):
    myIndivs = []
    for i in range(len(pops)-1):
        myIndivs.extend(MEGA.getIndivs(pops[i]))
        doPop(pops[i], sizes[i], MEGA.getIndivs(pops[i]))
    try:
        os.mkdir(os.sep.join([MEGA.cacheDB, "bundles"]))
    except OSError:
        pass #Already exists, OK
    bundleDir = os.sep.join([MEGA.cacheDB, "bundles", pop])
    try:
        os.mkdir(bundleDir)
    except OSError:
        pass #Already exists, OK
    w = open(bundleDir + os.sep + "basic", "w")
    w.write(str(sizes[-1]) + "\n")
    for i in range(len(pops)-1):
        w.write("\t".join([pops[i], str(sizes[i])]))
        w.write("\n")
    w.close()
    w = open(bundleDir + os.sep + "indivs", "w")
    w.write("\n".join(map(lambda x:str(x), myIndivs)) + "\n")
    w.close()



if len(lines)==2: #CORE POP
    size = int(lines[1])
    doPop(pop, size, MEGA.getIndivs(pop))
else:
    pops = []
    sizes = []
    for line in lines[1:]:
        toks = line.rstrip().split("\t")
        pops.append(toks[0].lstrip().rstrip())
        sizes.append(int(toks[1]))
    doBundle(pop, pops, sizes)
