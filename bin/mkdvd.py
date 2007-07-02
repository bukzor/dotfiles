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
	l = len(str(val))
	try:
	    self.attdict[name] = max(l, self.attdict[name])
	except:
	    self.attdict[name] = max(l, len(name))
    def __str__(self):
	#Pretty Printing =D
	s = ""
	attlist = self.attdict.keys()
	width = self.attdict
	for att in attlist:
	    s += att.ljust(width[att] + 3)
	s += "\n"
	for clip in self.clipdict.values():
	    for att in attlist:
		try: s += str(clip[att]).ljust(width[att] + 3)
		except KeyError: s += "".ljust(width[att] + 3)
	    s += "\n"
	return s
    def encode(self):
	for clip in self.clipdict.values():
	    clip.encode()


	

class Clip:
    def __init__(self, filename, List=None):
	r = re.compile("ID_(.*)=(.*)")
	r2 = re.compile(r"\(aspect ([^)]*)\)")

	self.List = List
	stdout = os.popen3("mplayer -identify -frames 0 " + filename)[1].read()

	attributes = r.findall(stdout)
	self.dict = {}
	for (name, val) in attributes:
	    self[name] = val
	try:
	    aspect = float(r2.findall(stdout)[0])
	    if(aspect == 2 or aspect == 12):
		self["ASPECT"] = 1.3333333
	    elif(aspect == 3):
		self["ASPECT"] = 1.7777778
	    else:
		print "%s: Unrecognized aspect (%i)" % (filename, aspect)
		raise Exception
	except:
	    self["ASPECT"] = self["VIDEO_WIDTH"]/self["VIDEO_HEIGHT"]

	    
    def __getitem__(self, attname):
	return self.dict[attname]
    def __setitem__(self, name, val):
	try: self.dict[name] = float(val)
	except ValueError: self.dict[name] = val
	try: self.List.newatt(name, val)
	except AttributeError: pass
    def is_dvd(self):
	"return whether the clip is in NTSC-DVD format"
	try: return self["IS_DVD"]
	except KeyError:
	    if( self["VIDEO_FORMAT"] == 0x10000002 and \
		self["AUDIO_FORMAT"] == 8192 and \
		self["AUDIO_RATE"]   == 48000 and \
		self["VIDEO_WIDTH"]  == 720 and \
		self["VIDEO_HEIGHT"] == 480 and \
		self["VIDEO_FPS"]    == 29.970):
		    self["IS_DVD"] = True
		    return True
	    else:
		    self["IS_DVD"] = False
		    return False
    def encode(self):
	name = self["FILENAME"]
	print name, ":",
	if(self.is_dvd()):
	    print "already NTSC-DVD encoded, skipping.\n"
	    return
	mencoder = "mencoder -of mpeg -ovc lavc"
	oac = " -oac"
	mpegopts = " -mpegopts format=dvd:tsaf"
	vf = " -vf "
	lavcopts = " -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=18"
	ofps = " -ofps"
	io = " -o %s.DVD.mpg %s" % (name, name)

	
	w = self["VIDEO_WIDTH"] 
	h = self["VIDEO_HEIGHT"]
	a = self["ASPECT"]

	if(a > 2.06):
	    if (abs((a - 2.35)/2.35) < .05):
		print "[Panavision]"
	    else: 
		print "[Panavision?]"

	    print "Converting to 720x480"
	    vf += "scale=720:368,expand=720:480,"
	    lavcopts += ":aspect=16/9"
	elif(a > 1.5556):
	    if(w == 720 and h == 480):
		print "[DVD-Wide]"
		print "Resolution OK!"
	    else:
		if (abs((a - 1.778)/1.778) < .05):
		    print "[Widescreen]"
		else: 
		    print "[Widescreen?]"
		print "Converting to 720x480"
		vf += "scale=720:480,"
	    lavcopts += ":aspect=16/9"
	else:
	    if(w == 720 and h == 480):
		print "[DVD-Normal]"
		print "Resolution OK!"
	    else:
		if (abs((a - 1.333)/1.333) < .05):
		    print "[Normal]"
		else: 
		    print "[Normal?]"
		print "converting to 720x480"
		vf += "scale=720:480,"
	    lavcopts += ":aspect=4/3"
	print "%ix%i = %.3f" % (w,h,a)

	fps = self["VIDEO_FPS"]
	print "fps =", fps
	if(fps == 25):
	    print "PAL framerate"
	    ofps += " 30000/1001"
	elif(fps == 29.970):
	    print "NTSC framerate. OK"
	    ofps += " 30000/1001"
	elif(fps == 23.976):
	    print "Film framerate. telecine"
	    ofps += " 24000/1001"
	    mpegopts += ":telecine"
	else:
	    print "Unrecognized framerate (%sfps)" % fps
	    ofps += " 30000/1001"

	a = self["AUDIO_FORMAT"]
	r = self["AUDIO_RATE"]
	if(a == 8192):
	    print "AC3 audio,",
	    if(r == 48000):
		print "48000Hz. OK"
		oac += " copy"
	    else:
		print "wrong rate (%sHz), converting." % r
		oac += " lavc -srate 48000 -af lavcresample=48000"
		lavcopts += ":acodec=ac3:abitrate=192"
	else:
	    print "Other audio. Converting to AC3"
	    oac += " lavc -srate 48000 -af lavcresample=48000"
	    lavcopts += ":acodec=ac3:abitrate=192"
	#harddup at end of filter chain to keep A/V sync
	vf += "harddup"

	run(mencoder + oac + mpegopts + vf + lavcopts + ofps + io)
	#print mencoder + oac + mpegopts + vf + lavcopts + ofps + io
	print

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
    CL.encode()
    print CL

    return 0

"""
NOTES:
NTSC = 30, 24 fps   PAL = 25 fps

24fps -> -mpegopts format=dvd:tsaf:telecine -ofps 24000/1001

2.35 aspect -> crop or pad to 16:9, align padding on 16pixels

AUDIO_RATE != 48000 -> -srate 48000 -af lavcresample=48000

ac3 audio -> -oac copy
other -> -oac lavc -lavcopts acodec=ac3:abitrate=192

always:
-of mpeg -mpegopts format=dvd:tsaf -harddup -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=15:vstrict=0:acodec=ac3

"""

	    

	


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
