#!/usr/bin/python
import sys

class animal:
	def __init__(self):
		print "An animal was born!"
		self.name = "animals"
		self.legs = "several"

	def getlegs(self):
		print "Most", self.name, "have", self.legs, "legs."


class horse(animal):
	def __init__(self):
		animal.__init__(self)
		print "A horse was born!"
		self.name = "horses"
		self.legs = 4

class chicken(animal):
	def __init__(self):
		print "A chicken has hatched!"
		self.name = "chickens"
		self.legs = 2

class wumpus(animal):
	def create(self):
		print "A wumpus has been conjured!"
		self.name = "wumpii"
		self.legs = 3
		

def main():
	print "Making an animal..."
	a = animal()
	print
	print "Making a horse..."
	h = horse()
	print
	print "Making a chicken..."
	c = chicken()
	print
	print "Planning a wumpus..."
	w = wumpus()
	print
	print "Creating a wumpus..."
	w.create()

	print
	print "And how many legs do these critters have?"
	a.getlegs()
	h.getlegs()
	c.getlegs()
	w.getlegs()
	
	print
	print "exiting..."


if __name__ == "__main__":
	sys.exit(main())
