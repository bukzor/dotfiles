#!/usr/bin/python
scancommand = "sudo iwlist eth1 scan"

import commands

scan = commands.getoutput(scancommand)
if scan.find('trucknet') > -1:
	print "Trucknet in range!"

if scan.find('planets') > -1:
	print "planets in range!"

if scan.find('UIUCnet') > -1:
	print "UIUCnet in range!"

