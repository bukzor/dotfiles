#!/usr/bin/python
import os

def rand():
	"""a random string"""
	return str(os.times()[4])

def run(command, errors = True):
	"""run commands errors=True
	runs a command, and exits on error (blocking)
	prints command output to terminal
	'command' is the command to run
	'errors' controls whether exceptions are thrown on error"""
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

def doc(obj):
	#print out all the documentation for a certain object
	print obj,":",
	if callable(obj):
		print "function"
	else:
		print type(obj)
	print obj.__doc__
	print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

	for x in dir(obj):
		print x,":",
		x = getattr(obj, x)
		if callable(x):
			print "function"
			print x.__doc__
		else:
			print type(x)
			print x
		print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

#run("svn add /home/golemon/emsvn.remote/*")
