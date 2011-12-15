import sys
import os
import subprocess
import MEGA

if len(sys.argv)!=1:
    print "python %s " % (sys.argv[0],)
    sys.exit(-1)


myPathLst = __file__.split(os.sep)[:-1]

if len(myPathLst)==0:
    myPath = ".."
else:
    myPath = os.sep.join(myPathLst[:-1])
    

pops = MEGA.pops

for pop in pops:
    os.system("python %s/basicInfo/pushWeb.py %s" % (myPath, pop))
