import ConfigParser as config
import os
import sys

def getRecord(l):
    #This is really a record from the meta database
    rec = {}
    toks = l.split("\t") #rstrip will remove the empty end tabs
    toks[-1]=toks[-1].rstrip() #remove just
    #To be extended
    rec["sampId"] = toks[0]
    rec["famId"] = toks[1]
    rec["pop"] = toks[2]
    rec["source"] = toks[9]
    return rec

def getPop4Indiv():
    indPop = {}
    f = open(metaDB + os.sep + "clean.tab")
    for l in f:
        rec = getRecord(l)
        indPop[rec["sampId"]] = rec["pop"]
    return indPop

def loadLocal(lcfg):
    cfg = config.ConfigParser()
    cfg.read(lcfg)
    MEGA = sys.modules[__name__]
    MEGA.popPairs = cfg.get("Data","popPairs")
    MEGA.allInds = cfg.get("Data","allInds")
    MEGA.ibd = cfg.get("Data","ibd")

cfg = config.ConfigParser()
cfg.read(os.path.expanduser("~/.megacfg"))
metaDB = cfg.get("DB","meta")
plinkDB = cfg.get("DB","plink")
del cfg
