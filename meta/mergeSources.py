import os
import sys

if len(sys.argv)!=3:
    print "python %s <tartu> <extended>" % (sys.argv[0],)
    sys.exit(-1)

tartu = sys.argv[1]
extended = sys.argv[2]

tRecs = {}
tHdl = open(tartu)
tHdl.readline() # header
for l in tHdl:
    toks = l.rstrip().split("\t")[12:]
    for i in range(len(toks), 23):
        toks.append("")
    oldId      = toks[0]
    sampId     = toks[1]
    famId      = toks[2]
    pop        = toks[3]
    region     = toks[4]
    localAdmin = toks[5]
    country    = toks[6]
    continent  = toks[7]
    lang       = toks[8]
    if toks[9].find("This S")>-1:
        toks[9]    = toks[9] + " Tartu"
    source     = toks[9]
    chip       = toks[10]
    census     = toks[11]
    mi         = toks[12]
    height     = toks[13]
    mtDNA      = toks[14]
    HVS1       = toks[15]
    YChro      = toks[16]
    purity     = toks[17]
    unrel      = toks[18]
    adults     = toks[19]
    r          = toks[20]
    jew3       = toks[21]
    rr         = toks[22]
    tRecs[(sampId,famId)] = [oldId] + toks[3:23]
    #print tRecs[(sampId,famId)]
tHdl.close()

print >>sys.stderr, "\t".join(["sampId", "famId", "pop", "refPop", "region", "localAdmin",
    "country", "continent", "lang", "source", "chip", "census", "mi",
     "height", "mtDNA", "HVS1",
    "YChro", "purity", "unrel", "adults", "r", "jew3", "rr", "oldId"])


done = set()
eHdl = open(extended)
eHdl.readline()
for l in eHdl:
    toks = l.rstrip().split("\t")[2:]
    sampId     = toks[0]
    famId      = toks[1]
    if (sampId, famId) in done: continue
    done.add((sampId, famId))
    pop        = toks[2]
    region     = toks[3]
    localAdmin = toks[4]
    country    = toks[5]
    continent  = toks[6]
    lang       = toks[7]
    source     = "Extended"
    chip       = toks[9]
    refPop     = toks[10]


    #Not used, but just to know positions...
    oldId      = ""
    census     = ""
    mi         = ""
    height     = ""
    mtDNA      = ""
    HVS1       = ""
    YChro      = ""
    purity     = ""
    unrel      = ""
    adults     = ""
    r          = ""
    jew3       = ""
    rr         = ""
    try:
        tartuInfo  = tRecs[(sampId, famId)]
        del tRecs[(sampId, famId)]
        oldId        = tartuInfo[0]
        pop          = tartuInfo[1]
        try: #Optional...
            region     = tartuInfo[2]
            localAdmin = tartuInfo[3]
            country    = tartuInfo[4]
            continent  = tartuInfo[5]
            lang       = tartuInfo[6]
            source     = tartuInfo[7]
            chip       = tartuInfo[8]
            census     = tartuInfo[9]
            mi         = tartuInfo[10]
            height     = tartuInfo[11]
            mtDNA      = tartuInfo[12]
            HVS1       = tartuInfo[13]
            YChro      = tartuInfo[14]
            purity     = tartuInfo[15]
            unrel      = tartuInfo[16]
            adults     = tartuInfo[17]
            r          = tartuInfo[18]
            jew3       = tartuInfo[19]
            rr         = tartuInfo[20]
        except IndexError:
            pass
    except KeyError:
        pass

    print "\t".join([sampId, famId, pop, refPop, region, localAdmin, country,
        continent, lang, source, chip, census, mi, height, mtDNA, HVS1,
        YChro, purity, unrel, adults, r, jew3, rr, oldId])
        
eHdl.close()
