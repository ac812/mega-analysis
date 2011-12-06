#!/usr/local/bin/python

import os
import sys
import ConfigParser as config
import MEGA

if len(sys.argv) not in [2]:
    print "Usage: %s lcfg" % (sys.argv[0].split("/")[-1],)
    sys.exit(-1)

cfg = sys.argv[1]
MEGA.loadLocal(cfg)
metaDB = MEGA.metaDB
ibd = MEGA.ibd

popCounts = {}

for l in open(metaDB + os.sep + "clean.tab"):
    rec = MEGA.getRecord(l)
    popCounts.setdefault(rec["pop"], []).append(rec["sampId"])

popNames = popCounts.keys()
popNames.sort()
for pop in popNames:
    if pop=="": continue #clean has to sort this (curation is better)
    sys.stdout.write(pop + "\t" +  str(len(popCounts[pop])) + "\t")
    pop=pop.rstrip() #clean has to sort this 
    ibp = open(ibd + os.sep + pop.replace(" ", "_") + "_keep.txt")
    sys.stdout.write(str(len(ibp.readlines())) + "\t")
    rp = open(ibd + os.sep + pop.replace(" ", "_") + "_remove.txt")
    sys.stdout.write(str(len(rp.readlines())) + "\n")
