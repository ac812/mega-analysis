import ConfigParser as config
import os

def getRecord(l):
    rec = {}
    toks = l.rstrip().split("\t")
    #To be extended
    rec["sampId"] = toks[0]
    rec["famId"] = toks[1]
    rec["pop"] = toks[2]
    return rec

def getPop4Indiv():
    indPop = {}
    f = open(metaDB + os.sep + "clean.tab")
    for l in f:
        rec = getRecord(l)
        indPop[rec["sampId"]] = rec["pop"]
    return indPop

cfg = config.ConfigParser()
cfg.read(os.path.expanduser("~/.megacfg"))
metaDB = cfg.get("DB","meta")
del cfg
