import sys

def parseNearest(f):
    f.readline() #Header file
    for l in f:
        fid = l[:12]
        iid = l[12:25]
        nn = int(l[25:32])
        min_dst = float([32:45])
        z = float()
        fid2 = l[:]
        iid2 = l[:]
        prop_diff = l[:]
        yield {"fid": fid, "iid": iid, "nn": nn, "min_dst": min_dst,
               "z": z , "fid2": fid2, "iid2": iid2, "prop_diff": prop_diff}
    f.close()


if __name__ == "__main__":
    if len(sys.argv)==2:
        fname = sys.argv[1]
        if fname.endswith(".nearest"):
            for rec in parseNearest(open(fname)):
                print rec
