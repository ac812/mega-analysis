#!/usr/local/bin/python

import os
import re
import shutil
import sys
import ConfigParser as config

if len(sys.argv)!=1:
    print "Usage: %s" % (sys.argv[0].split("/")[-1],)
    sys.exit(-1)

cfg = config.ConfigParser()
cfg.read(os.path.expanduser("~/.megacfg"))
geoDB = cfg.get("DB","geo")

print """
<?xml version="1.0" encoding="utf-8"?>
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
""" 

g = open(geoDB)
id = 0
for l in g:
    toks = l.rstrip().split("\t")
    pop = toks[0]
    long = float(toks[1])
    lat = float(toks[2])
    id += 1
    print """
  <Placemark>
    <name>%s</name>
    <description>%s</description>
    <Point>
    <coordinates>%f,%f</coordinates>
    </Point>
  </Placemark>
""" % (pop, pop, long, lat)

print "</kml>"
