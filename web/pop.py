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

print '<a href="mega.py">Main page</a>' 
print "<title>%s</title>" % (pop,)
print "<h1>%s</h1>" % (pop,)

isBundle = pop in MEGA.bundles

if isBundle:
    mid = "bundles"
    print "<h2>Bundle</h2>"
    for p in MEGA.bundles[pop]:
        print web.getPopURL(p) + ", "
else:
    mid = "pops"
    print "<b>Core pop</b>"
    myBundles = []
    for bundle in MEGA.bundles:
        if pop in MEGA.bundles[bundle]:
            myBundles.append(bundle)
    if len(myBundles)>0:
        print "I am in the following bundles: %s" %(", ".join(web.getPopsURLs(myBundles)))


print """
<table border="1">
<tr>
<td valign="top">
"""
print "<h2>Basic info</h2>"
if isBundle:
    try:
        f = open("%s/%s/%s/basic" %(MEGA.cacheDB, mid, pop))
        print "<table border=1><tr><td><b>total</b></td><td>%s</td></tr><tr>" % (f.readline(),)
        for l in f:
            print "<tr><td>"
            print "</td><td>".join(l.split("\t"))
            print "</td></tr>"
        print "</table>"
    except IOError:
        print "Not available"
else:
    print "<b>Number of individuals:</b>"
    try:
        f = open("%s/%s/%s/basic" %(MEGA.cacheDB, mid, pop))
        print f.readline()
        f.close()
        f = open("%s/%s/%s/distant" %(MEGA.cacheDB, mid, pop))
        print "<br>Of which %d are distant<br>" % (len(f.readlines()),)
        f.close()
        f = open("%s/%s/%s/close" %(MEGA.cacheDB, mid, pop))
        print "<br><b>%s usable</b> at 12.5%% cut:<br>" % (f.readline(),)
        f.close()
    except IOError:
        print "Not available"
      
if isBundle:
    print "<h2>Admixture</h2>"
    try:
        rest = ""
        f = open("%s/%s/%s/admixture" %(MEGA.cacheDB, mid, pop))
        print "<table border=1><tr><td>Pops</td><td>CV</td></tr>"
        for l in f:
            cv = int(l.split("\t")[0])
            print "<tr><td>"
            print "</td><td>".join(l.split("\t"))
            print "</td></tr>"
            rest += '<h3>%d</h3><img src="../ma/bundles/%s/adm%d.png"><br/>' %(cv, pop, cv)
            #XXX hardcoded dir above!
        print "</table>"
        print rest
    except IOError:
        print "Not Available"
    
print "<h2>Inbreeding</h2>"
if isBundle:
    try:
        f = open("%s/%s/%s/statIBD" %(MEGA.cacheDB, mid, pop))
        print "<table border=1>"
        for l in f:
            print "<tr><td>"
            print "</td><td>".join(l.split("\t"))
            print "</td></tr>"
        print "</table>"
    except IOError:
        print "Not available"

print "</td><td valign=top>"
try:
    f = open("%s/%s/%s/indivs" %(MEGA.cacheDB, mid, pop))
    print "<table>"
    for l in f:
        ind, fam = eval(l)
        print "<tr><td>%s</td><td>%s</td></tr>" %(ind,fam)
    print "</table>"
    f.close()
except:
    pass
print "</td></tr></table>"
