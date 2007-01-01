#!/usr/bin/python2.4


from sys import argv
from operator import itemgetter


def sortandprint(d):
	d = d.items()
	d = sorted(d, cmp, itemgetter(1), True)
	d = d[:10]
	s = 0

	for x in d:
		l = len(x[0])
		l = x[1]*(l - 1) - (l + 1)
		print repr(x[0]), l
		s += l
	print "Total compression:", s

def main():
	f = file(argv[1])
	try:
		length = int(argv[2])
	except:
		print "defaulting to compress 3"
		length = 3

	for 
	d = [{}, {}, {}]
	s = f.read(length)

	while len(s) == length:
		if s in d:
			d[s] += 1
		else:
			d[s] = 1
		s = s[1:] + f.read(1)
	
	sortandprint(d)

main()

"""
file format:
[substitution list][data]

subtitution list:
[number of substitutions][substitution][substitution]...

substitution:
[symbol length][symbol][replaced string]

NOTE: "symbol" must be a string not found in the original,
	and must not be accidentally generated during compression:
"""

