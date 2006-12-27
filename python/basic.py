#!/usr/bin/python
import os

def rand():
	"""rand () -> a random string
this can be converted to a floating point number"""
	return str(os.times()[4])

def run(command, errors = True):
	"""run(commands, errors=True)
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
	"""doc(object)
prettyprint all the documentation for an object, as well as all the objects it contains"""

	s = repr(obj) + " : "
	if callable(obj):
		s += " function"
	else:
		s +=  repr(type(obj))
	s += "\n"
	s +=  obj.__doc__
	s +=  "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"

	for x in dir(obj):
		if x[:2] != "__":
			s +=  x + " : "
			x = getattr(obj, x)
			if callable(x):
					s +=  "function\n"
					s +=  x.__doc__
			else:
					s +=  repr(type(x))
					s += "\n"
					s +=  str(x)
			s +=  "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
	return s


#run("svn add /home/golemon/emsvn.remote/*")
