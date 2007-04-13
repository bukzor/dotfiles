#!/usr/bin/python

#packages used: mencoder, mplayer, dvdauthor, dvd+rw-tools

#identify: mplayer -identify -frames 0 $file
import os
import sys
import re

dryrun=False

filedict={}

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

    attdict = {}
    r = re.compile("ID_(.*)=(.*)")
    for file in filelist:
	stdout = os.popen3("mplayer -identify -frames 0 " + file)[1]
	attributes = r.findall(stdout.read())
	dict = {}
	for att in attributes:
	    dict[att[0]] = att[1]
	    try:
		attdict[att[0]] = max(len(att[1]), attdict[att[0]])
	    except:
		attdict[att[0]] = max(len(att[1]), len(att[0]))
	filedict[file] = dict

    attlist = attdict.keys();
    for att in attlist:
	print att.ljust(attdict[att]),
    print

    for file in filelist:
	for att in attlist:
	    try:
		d = filedict[file]
		print filedict[file][att].ljust(attdict[att]),
	    except KeyError:
		print "".ljust(attdict[att]),
	print

    return 0

	    

	
    """
    for x in files:
	run("mplayer -identify -frames 0 %s > %s.id" % (x, x))

							      """


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
