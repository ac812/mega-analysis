def getRecord(l):
    rec = {}
    toks = l.rstrip().split("\t")
    #To be extended
    rec["sampId"] = toks[0]
    rec["famId"] = toks[1]
    rec["pop"] = toks[2]
    return rec
