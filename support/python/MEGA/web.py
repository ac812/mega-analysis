def getPopURL(pop):
    return '<a href="pop.py?p=%s">%s<a>' %(pop,pop)

def getPopsURLs(pops):
    return map(lambda x:getPopURL(x), pops)
