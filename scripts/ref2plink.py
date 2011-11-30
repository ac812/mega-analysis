import sys

if len(sys.argv)!=2:
    print "python %s POP" % (sys.argv[0],)
    print "POP is YRI or CEU"
    sys.exit(-1)

pop = sys.argv[1]
out = open("reflist.txt", "w")
out.close()
