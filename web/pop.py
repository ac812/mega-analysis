#!/usr/bin/python
import cgi
import cgitb
import os
import sys
sys.stderr = sys.stdout
import ConfigParser

cgitb.enable()

cfg = ConfigParser.ConfigParser()
cfg.read(os.path.expanduser("~/.megacfg"))

sys.path.insert(0, cfg.get("System", "pythonInclude"))
print "Content-Type: text/html"     # HTML is following
print                               # blank line, end of headers


import MEGA
from MEGA import web

form = cgi.FieldStorage()
pop = form["p"].value

print "<title>%s</title>" % (pop,)
print "<h1>%s</h1>" % (pop,)

isBundle = pop in MEGA.bundles

if isBundle:
    print "<h2>Bundle</h2>"
    for p in MEGA.bundles[pop]:
        print web.getPopURL(p) + "\n<br>"
else:
    print "Core pop"
    myBundles = []
    for bundle in MEGA.bundles:
        if pop in MEGA.bundles[bundle]:
            myBundles.append(bundle)
    if len(myBundles)>0:
        print "I am in the following bundles: %s" %(", ".join(web.getPopsURLs(myBundles)))


print "<h2>Studies</h2>"
print """
<table border="1">
<tr>
  <td>Study</td>
  <td>Study pops</td>
  <td>Out pops</td>
</tr>
"""
for study in MEGA.studies:
    ins, outs = MEGA.studies[study]
    inURLs = map(lambda x:web.getPopURL(x), ins)
    outURLs = map(lambda x:web.getPopURL(x), outs)
    print "<tr><td>%s</td><td>%s</td><td>%s</td></tr>" % (study, ", ".join(inURLs), ", ".join(outURLs))
print "</table>"



print "<h2>Bundles</h2>"
print """
<table border="1">
<tr>
  <td>Bundle</td>
  <td>Inside</td>
</tr>
"""
for bundle in MEGA.bundles:
    pops = MEGA.bundles[bundle]
    print "<tr><td>%s</td><td>%s</td></tr>" % (bundle, ", ".join(pops))
print "</table>"



print "<h2>Populations</h2>"

pops = MEGA.pops
print '<table border="1">'
curr=0
print "<tr>"
for pop in pops:
    print "<td>%s</td>" %(pop,)
    if curr % 6 == 0:
        print "</tr><tr>"
    curr += 1
print "</tr>"
print "</table>"
