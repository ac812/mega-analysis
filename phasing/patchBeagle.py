import sys

for l in sys.stdin:
    toks = l.split("\t")[::2]
    print "\t".join(toks),
    
