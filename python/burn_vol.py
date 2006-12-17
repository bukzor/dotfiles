#!/usr/bin/python

import sys
import os

def getdisc():
	run("eject")
	raw_input(">>> Press <Enter> when ready. <<<")
	run("eject -t") #closes the drive
	
#runs a command, and exits on error (blocking)
#prints command output to terminal
def run(command):
	args = command.split()
	if os.spawnvp(os.P_WAIT, args[0], args):
		print ">>>"
		print ">>>"
		print ">>>"
		print ">>>"
		print ">>> Error running %s! Exiting..." % args[0]
		print ">>>"
		print ">>>"
		print ">>>"
		print ">>>"
		run("eject")
		sys.exit(-1)

if len(sys.argv) == 1:
	print "burn_vol.py: Burn volumes created by dirsplit.py"
	print "usage: './burnvol.py vol_001.list vol_002.list ...'"
	sys.exit(0)

for vol in sys.argv[1:]:
	if not os.path.isfile(vol):
		print "Cannot stat", vol + ", exiting..."
		sys.exit(-1)


for vol in sys.argv[1:]:
	print "Please insert a blank DVD to burn \"" + vol + "\""
	getdisc()
	run("growisofs -use-the-force-luke=dao -speed=6 -dvd-compat -Z /dev/dvd\
	-R -J -iso-level 4 -joliet-long -D -graft-points -path-list " + vol)
	print "Burning complete! Closing disc..."
	run("cdrecord dev=ATA:1,0,0 -fix -v")
run("eject")
print "Task complete!"
sys.exit(0)
