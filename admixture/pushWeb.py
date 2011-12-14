import sys
import os
import shutil
import subprocess
import MEGA

if len(sys.argv) not in [2]:
    print "python %s bundle" % (sys.argv[0],)
    sys.exit(-1)

bundle = sys.argv[1]

lst = os.listdir(".")
CVs = {}

def doBundle(bundle, CVs):
    try:
        os.mkdir(os.sep.join([MEGA.cacheDB, "bundles"]))
    except OSError:
        pass #Already exists, OK
    bundleDir = os.sep.join([MEGA.cacheDB, "bundles", bundle])
    try:
        os.mkdir(bundleDir)
    except OSError:
        pass #Already exists, OK
    bw = open(bundleDir + os.sep + "admixture", "w")
    nPops = CVs.keys()
    nPops.sort()
    for n in nPops:
        bw.write(str(n) + "\t" + str(CVs[n]) + "\n")
        shutil.copyfile(str(n)+".png", bundleDir + os.sep + "adm"+str(n)+".png")
    bw.close()

for fn in lst:
    if fn.startswith(bundle+".") and len(fn)==len(bundle)+2:
        f = open(fn)
        ls = f.readlines()
        myL = filter(lambda x: x.find("CV error")> -1, ls)[0]
        CVs[int(fn[-1])] = float(myL.split(":")[1])
        f.close()

doBundle(bundle, CVs)
