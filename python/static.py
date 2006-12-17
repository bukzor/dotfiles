#!/usr/bin/python
class Thing:
	"Demonstrates a static variable"
	num = 0
	def __init__(self):
		print "Thing created!"
		Thing.num += 1
		self.num = Thing.num


a = Chunk()
b = Chunk()
c = Chunk()
print a.num, b.num, c.num
