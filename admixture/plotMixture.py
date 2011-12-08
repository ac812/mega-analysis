import numpy as np
import matplotlib.pyplot as plt
import sys

if len(sys.argv) not in [3]:
    print "%s admixfile reorder" % (sys.argv[0],)
    sys.exit(-1)
 
fname = sys.argv[1]
of = open(sys.argv[2])
pos = [] #pos, pop, indiv
for l in of:
    toks = l.rstrip().split("\t")
    pos.append((int(toks[0]), toks[1], toks[2]))
of.close()

pops = {}
colors = ["r", "g", "b", "y", "m", "c"]

f = open(fname)
numIndivs = 0
for l in f:
    numIndivs += 1
    toks = map(lambda x: float(x), l.rstrip().split(" "))
    for i in range(len(toks)):
        pops.setdefault(i, []).append(toks[i])

reoPops = {}
for pop, ks in pops.items():
    newKs = []
    for allPos in pos:
        newKs.append(ks[allPos[0]])
    reoPops[pop] = newKs

bottom = []
for i in range(numIndivs):
    bottom.append(0.0)
for pop, ks in reoPops.items():
    plt.bar(range(numIndivs), ks, color=colors[pop], linewidth=0, bottom=bottom)
    for i in range(numIndivs):
        bottom[i] += ks[i]

currPop=pos[0][1]
cnt = [1]
pops = [currPop]
for line in pos:
    if line[1] == currPop:
        cnt[-1] += 1
    else:
        currPop=line[1]
        pops.append(currPop)
        cnt.append(1)

acu = 0
for pi in range(len(cnt)):
    pos = cnt[pi]
    acu += pos
    plt.text(acu, 1.0, pops[pi], ha="right", va="bottom", rotation="vertical")
    plt.axvline(acu, color="black", lw=0.5) 

plt.savefig("x.eps")

