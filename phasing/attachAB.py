import sys

for l in sys.stdin:
    toksA = l.rstrip().split("\t")
    toksB = l.rstrip().split("\t")
    toksA[0] += "_A"
    toksA[1] += "_A"
    toksB[0] += "_B"
    toksB[1] += "_B"
    print "\t".join(toksA)
    print "\t".join(toksB)
