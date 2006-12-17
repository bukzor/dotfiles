#/usr/bin/python

import re

dat = open("equality.dat", "r").read()

t = ""
list = re.findall("[^A-Z][A-Z]{3}([a-z])[A-Z]{3}[^A-Z]", dat)
for l in list:
	t += l
print t
print list
