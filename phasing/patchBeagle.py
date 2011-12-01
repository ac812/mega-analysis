import os
import sys

if len(sys.argv)==1:
    path = "."
else:
    path = sys.argv[1]

files = os.listdir(path)
for file in files:
    if file.find("trios")==-1:
        continue
    core = path + os.sep + file
    r = open(core)
    w = open(core + ".W", "w")
    for l in r:
        toks = l.split("\t")[::2]
        w.write("\t".join(toks))
    os.rename(core + ".W", core)
