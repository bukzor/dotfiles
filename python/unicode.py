#!/usr/bin/python
import sys


def main(argv = None):
	if argv is None:
		argv = sys.argv;

	if len(argv) != 3:
		print "Exactly two arguments needed\n"
		return 2
	else:
		try:
			start = int(argv[1])
			end = int(argv[2]) + 1
		except ValueError:
			try:
				start = int(argv[1], 16)
				end = int(argv[2], 16) + 1
			except ValueError:
				print "Numeric arguments needed\n"
				return 2

	div=min(max((end - start)//10, 1), 40)
	for step in xrange(start, end, div):
		print u"\n\\u%04X = %c" % (step, step)
		for val in xrange(step, min(step + div, end)):
			print u"%c" % (val),


if __name__ == "__main__":
	ret = main(sys.argv)
	if ret:
		print sys.argv[0], ": prints a range of unicode characters."
		sys.exit("usage: %s start end" % sys.argv[0])
	sys.exit(ret)
		
