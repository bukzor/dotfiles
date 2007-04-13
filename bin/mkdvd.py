#!/usr/bin/python

#packages used: mencoder, mplayer, dvdauthor, dvd+rw-tools

#identify: mplayer -identify -frames 0 $file
import os
import sys
import re

dryrun=False

class ClipList:
    def __init__(self):
	self.attdict = {}
	self.clipdict = {} #holds maximum width of attributes, for printing 
    def AddClip(self, filename):
	C = Clip(filename, self)
	self.clipdict[filename] = C
    def newatt(self, name, val):#just to help prettyprint
	try:
	    self.attdict[name] = max(len(val), self.attdict[name])
	except:
	    self.attdict[name] = max(len(val), len(name))
    def __str__(self):
	s = ""
	attlist = self.attdict.keys()
	width = self.attdict
	for att in attlist:
	    s += att.ljust(width[att] + 3)
	s += "\n"
	for clip in self.clipdict.values():
	    for att in attlist:
		try: s += clip[att].ljust(width[att] + 3)
		except KeyError: s += "".ljust(width[att] + 3)
	    s += "\n"
	return s

	

class Clip:
    r = re.compile("ID_(.*)=(.*)")
    def __init__(self, filename, List=None):
	self.List = List
	stdout = os.popen3("mplayer -identify -frames 0 " + filename)[1]
	attributes = Clip.r.findall(stdout.read())
	self.dict = {}
	for (name, val) in attributes:
	    self.dict[name] = val
	    try: List.newatt(name, val)
	    except AttributeError: pass
    def __getitem__(self, attname):
	return self.dict[attname]
    def __setitem__(self, attname, val):
	self.dict[attname] = val

	

def run(command, errors = True, dryrun = False):
    """run(commands, errors=True)
    runs a command, and exits on error (blocking)
    prints command output to terminal
    'command' is the command to run
    'errors' controls whether exceptions are thrown on error"""

    print ">>>\t" + command
    ret = os.spawnlp(os.P_WAIT, "sh", "sh", "-c", command)
    if ret:
        #error case
        if errors:
            raise OSError(\
  """>>>
     >>>
     >>>
     >>> Error running command! Exiting...
     >>> \"%s\"
     >>>
     >>>""" % command)
        else:
            return ret
    else:
        #success case
        return ret

def main(filelist):
    CL = ClipList()

    for file in filelist:
	CL.AddClip(file)
    print CL


    return 0

	    

	
    """
    for x in files:
	run("mplayer -identify -frames 0 %s > %s.id" % (x, x))

							      """


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
