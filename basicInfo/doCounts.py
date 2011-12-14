import sys
import MEGA

if len(sys.argv)!=2:
    print "python %s pop" % (sys.argv[0],)
    sys.exit(-1)

pop=sys.argv[1]

if pop in MEGA.bundles:
    print "BUNDLE"
    myPops = MEGA.bundles[pop]
    cnt = 0
    for myPop in myPops:
        myLen = len(MEGA.getIndivs(myPop))
        print "%20s\t%5d" % (myPop, myLen)
        cnt += myLen
    print "%20s\t%5d" %("All", cnt)
else:
    print "CORE POP"
    print len(MEGA.getIndivs(pop))
