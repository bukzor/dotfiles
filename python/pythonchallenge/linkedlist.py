#!/usr/bin/python
import urllib
import re
import sys

urlbase = "http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing="
nothing = "and the next nothing is "
html = nothing + sys.argv[1]
num = 0
while nothing in html:
	number = re.findall("[0-9]+$",html)[0]	
	html = urllib.urlopen(urlbase + number).read()
	num += 1

	print "%i: %s" % (num, html)
