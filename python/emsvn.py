#!/usr/bin/python
"""emsvn: A script to perform svn functions on an embedded system.
It is recommended that you have ssh keys set up on the remote system."""

#TODO make copy only copy specific files
#TODO make switch not make a ".emsvn" if it doesnt need to
#TODO figure out how to use timestamps to detect modification and optimize

import sys
import os
import commands
import basic


#fill out the documentation
def docgen():
	"""Generates the documentation.
    As a side benefit, forces all functions to have a __doc__ string"""
	global __doc__

	__doc__ += """\n\nsubcommands:"""
	for x in globals():
		if callable(globals()[x]) and globals()[x].__doc__.startswith("*"):
			__doc__ += "\n\n" + globals()[x].__doc__


def info(path = "."):
	"""* info path=.
	Returns a tuple of (server, local, remote, files) paths for the specified
	file(s)/folder"""
	#make sure argument is a directory
	files=""
	path = os.path.abspath(path)
  	if not os.path.isdir(path):
		files=os.path.basename(path)
		path = os.path.dirname(path)
		if not os.path.isdir(path):
			raise OSError("No such file")

  
	cwd = os.getcwd()
	os.chdir(path)
	while not os.path.isfile(".emsvn") and not os.getcwd() == "/" :
		os.chdir("..")
	if os.path.isfile(".emsvn"):
		remote = open(".emsvn", "r").readline()
		if ":" in remote:
			(server, remote) = remote.split(":")
		else:
			server = None
		relpath = path[len(os.getcwd()):] #strip off the base working dir
		remote = os.path.join(remote, relpath)
		os.chdir(cwd)
		return (server, path, remote, files)

	raise OSError("\"" + path + "\"" + " is not an emsvn working directory")


def pack(path = "."):
	"""* pack path=.
  - packs all the extended information into ".emsvn.modes" """
  	#TODO use 'mount' to figure out partitions to skip
	import stat

	cwd = os.getcwd()
	os.chdir(path)
	print "Packing...",
	for curdir, dirs, files in os.walk("."):
		all = dirs + files
		all.sort()

		modes = os.path.join(curdir, ".emsvn.modes")
		if os.path.exists(modes):
			#don't repack
			print
			print modes.ljust(31), "already exists.\
This directory is probably already packed"
			continue
		try:
			modes = open(modes, "w")
		except:
			#hopefully just a proc filesystem or such
			print "PACK: skipping", curdir
			dirs[:] = [] #don't descend further
			continue
		modes.write(curdir + "\n")
		modes.write(\
"File				Mode	UID	GID	aTime		mTime		Type	Extra\n")
		for file in all:
			if ".emsvn" in file:
				#skip emsvn files
				continue

			filepath = os.path.join(curdir,file)
			s = os.lstat(filepath)

			#write common imformation
			Mode = s.st_mode #number representing the permissions and type
			UID = s.st_uid
			GID = s.st_gid
			aTime = s.st_atime
			mTime = s.st_mtime
			modes.write("%s %d	%d	%d	%d	%d	" % \
				(file.ljust(32), Mode, UID, GID, aTime, mTime))

			#write the rest of the information
			if stat.S_ISLNK(Mode):
				#symbolic link
				modes.write("LINK	%s\n" % os.readlink(filepath))
			elif stat.S_ISFIFO(Mode):
				#named pipe
				modes.write("FIFO	-\n")
			elif stat.S_ISCHR(Mode) or stat.S_ISBLK(Mode):
				#device
				modes.write("DEV	%d\n" % s.st_rdev)
			elif stat.S_ISDIR(Mode):
				modes.write("DIR	-\n")
			else:
				modes.write("REG	-\n")
		modes.close()
	os.chdir(cwd)
	print "finished."

def unpack(path = "."):
	"""* unpack path=.
  - unpacks all the .emsvn.modes files in the specified directory tree"""
	cwd = os.getcwd()
	os.chdir(path)
	print "Unpacking...",
	#needs to walk bottom-up to get directory timestamps correct
	for curdir, x, x  in os.walk(".", False):
		modespath = os.path.join(curdir, ".emsvn.modes")
		try:
			modes = open(modespath, "r")
		except IOError:
			continue
		#discard top two lines
		modes.readline()
		modes.readline()
		for line in modes:
			(file, Mode, UID, GID, aTime, mTime, Type, Extra) = line.split()

			#reformatting
			Mode = int(Mode); UID = int(UID); GID = int(GID)
			aTime = int(aTime); mTime = int(mTime)
			file = os.path.join(curdir, file)
	
			#output
			if Type == "LINK":
				if os.path.lexists(file):
					#TODO check if removal is necessary
					os.remove(file)
				os.symlink(Extra, file)
				#no need for chmod
				os.lchown(file, UID, GID)
				#there is no way to set timestamps on links, even from C
				#os.utime(file, (aTime, mTime))
			elif Type == "DEV":
				if os.path.lexists(file):
					#TODO check if removal is necessary
					os.remove(file)
				os.mknod(file, Mode, int(Extra))
				os.lchown(file, UID, GID)
				os.utime(file, (aTime, mTime))
			elif Type == "FIFO":
				if os.path.lexists(file):
					#TODO check if removal is necessary
					os.remove(file)
				os.mkfifo(file, Mode)
				os.lchown(file, UID, GID)
				os.utime(file, (aTime, mTime))
			elif Type == "DIR" or Type == "REG":
				if not os.path.lexists(file):
					os.mkdir(file)
				os.chmod(file, Mode)
				os.lchown(file, UID, GID)
				os.utime(file, (aTime, mTime))
			else:
				print "Unkown file type!! :", file
				return -1
		os.remove(modespath)
	os.chdir(cwd)
	print "finished."

			
				
	return 0
				


	
def checkout(repo, remote, local = "."):
	"""* checkout/co repo remote localpath
  - check out a working copy from 'repos' to 'remotepath'
    and ensure that 'localpath' always matches 'remotepath'"""
	if ":" in remote:
		(server, path) = remote.split(":")
		basic.run("ssh %s svn co %s %s" % (server, repo, path))
		copyback(remote, local)
		unpack(local)
	else:
		basic.run("svn co %s %s" % (repo, remote))
		copyback(remote, local)
		unpack(local)
	return 0
		


def getversionedfiles(remote):
	"""* getversionedfiles remote
  - returns the list of versioned files in an svn working directory
    all paths are relative to the original path"""
	if ":" in remote:
		(server, remote) = remote.split(":")
		if remote == "":
			remote = "."
		(ret, svn) = commands.getstatusoutput("ssh %s svn status -v %s"\
			% (server, remote))
	else:
		(ret, svn) = commands.getstatusoutput("svn status -v %s"\
			% (remote))

	if ret:
		raise OSError(svn)

	svn = svn.split("\n") #split string into a list

	#strip out the directories, unrevisioned files, and extra info 
	skip = 40 + len(remote) #40 = length of extra info
	list = []
	for line in svn:
		if not line.startswith("?"):#unversioned files are marked with '?'
			list.append(line[skip:])
	return list
		
	
def copyback(remote, local = ".", server = None):
	"""copyback remote local=. server=None
	inverse operation from 'copy'"""
 	if server:
		remote = server + ":" + remote
 	elif not ":" in remote:
		remote = os.path.abspath(remote)

	list = getversionedfiles(remote)
	for file in list:
		#make sure the directory exists
		localfile = "%s/%s" % (local, file)
		remotefile = "%s/%s" % (remote, file)
		dir = os.path.dirname(localfile)
		if dir and not os.path.exists(dir):
			os.makedirs(dir)
		
		#run scp, print but ignore any errors (caused by copying folders)
		basic.run("scp %s %s" % (remotefile, localfile), False)
	return 0
		
def switch(remote, local = "."):
	"""* switch/sw remote local=.
  - make emsvn 'local' match existing svn working-copy 'remote'"""
  	copyback(remote, local)
	open(os.path.join(local, ".emsvn"), "w").write(remote)
	unpack(local)
	
	
def commit(path = ".", message = ""):
	"""* commit/ci path=. "message"
  - commit local changes to svn
    example:
    	emsvn ci path/to/file "Fixed several bugs\""""

	#initialization
	if not os.path.lexists(path):
		message = path + message
		path = "."
		
	#force log messages
	if not message:
		print commit.__doc__
		print "\nPlease provide a log message."
		return -1

	(server, local, remote, files)= info(path)
	pack(local)
	copy(local, remote, server)
	unpack(local)
	if server:
		basic.run("ssh %s svn add %s/*" % (server, remote), False)
		basic.run("ssh %s \"cd %s; svn commit -m \\\"%s\\\"\"" % (server, remote, message))
	else:
		basic.run("svn add %s/*" % remote, False)
		basic.run("svn commit %s -m \"%s\"" % (remote, message))

def update(path = "."):
	"""* update/up path=.
  - update svn changes to local files"""
	(server, local, remote, files) = info(path)
	pack(local)
	copy(local, remote, server)
	if server:
		basic.run("ssh %s svn update %s" % (server, remote))
	else:
		basic.run("svn up %s" % remote)
	copyback(remote, local, server)
	unpack(local)
	

def status(path = "."):
	"""* status path=.
	- view status of local files"""
	(server, local, remote, files) = info(path)
	
	pack(local)
	copy(local, remote, server)
	unpack(local)
	if server:
		basic.run("ssh %s svn status %s/%s" % (server, remote, files))
	else:
		basic.run("svn status %s/%s" % (remote, files))
	
	

def revert(path = "."):
	"""* revert path=.
	- change files to previous state"""
	(server, local, remote, files) = info(path)
	pack(local)
	copy(local, remote, server)
	if server:
		basic.run("ssh %s svn revert %s/%s" % (server, remote, files))
	else:
		basic.run("svn revert %s/%s" % (remote, files))
	copyback(remote, local, server)
	unpack(local)

def log(path = "."):
	"""* log path=.
  - view svn log"""
	(server, local, remote, files) = info(path)
	pack(local)
	copy(local, remote, server)
	unpack(local)
	if server:
		basic.run("ssh %s svn log %s/%s" % (server, remote, files))
	else:
		basic.run("svn status %s/%s" % (remote, files))

def diff(path = "."):
	"""* diff path=.
  - view local changes"""
	(server, local, remote, files) = info(path)
	pack(local)
	copy(local, remote, server)
	unpack(local)
	if server:
		basic.run("ssh %s svn diff %s/%s" % (server, remote, files))
	else:
		basic.run("svn diff %s/%s" % (remote, files))


def copy(local, remote, server = None):
	"""* copy local remote
  - copies all regular files from local to remote
    does folder merging
    use 'copy' for reverse operation"""

	#initializations
	if ":" in remote:
		(server, remote) = remote.split(":")
	local = os.path.abspath(local)
	skip = len(local)

	#copy the whole thing over
	for curdir, x, files in os.walk(local):
		#make sure this is a packed directory
		if not os.path.isfile(os.path.join(curdir, ".emsvn.modes")):
			print "COPY: skipping", curdir
			x[:] = [] #don't descend further
			continue
		#get relative folder path
		curdir = curdir[skip:]
		#make sure remote folder exists
		dir = os.path.join(remote, curdir)
		if dir:
			if server:
				basic.run("ssh %s mkdir -p %s" % (server, dir))
			else:
				if not os.path.isdir(dir):
					os.makedirs(dir)
		#alphabetical ordering...
		files.sort()


		for file in files:
			#this gets the relative path, from export root
			file = os.path.join(curdir, file)
			#absolute paths
			remotefile = os.path.join(remote, file)
			localfile = os.path.join(local, file)
			if os.path.isfile(localfile) and not os.path.islink(localfile):
				if server:
					basic.run("scp %s %s:%s" % (localfile, server, remotefile))
				else:
					basic.run("cp %s %s" % (localfile, remotefile))
	if server:
		basic.run("ssh %s chmod -R 700 %s" % (server, remote))
	else:
		basic.run("chmod -R 700 %s" % (remote))
		


def export(path, remotepath = None):
	"""* export [path=.] [[user@]host:]remotepath
  - create remote directory ready for 'svn import'
    remote directory should not already exist"""

	#initialization
	if remotepath == None:
		#1 argument, using default for path, need arguments switched
		remotepath = path
		path = "."

	#export = pack, copy, unpack
	pack(path)
	copy(path, remotepath)
	unpack(path)
	

#main function
def main(argv = None):
	"Called when emsvn is invoked from bash"
	if argv == None:
		argv = sys.argv
	
	#commandline argument processing
	if len(argv) >= 2:
		command = argv[1];

		#expand the short command names
		if command == "co":
			command = "checkout"
		elif command == "sw":
			command = "switch"
		elif command == "ci":
			command = "commit"
		elif command == "up":
			command = "update"
		
		#find and call the command
		if command in globals().keys():
			try:
				func = globals()[command]
				args = argv[2:]
				return func(*args)
			except:
				print globals()[command].__doc__
				raise
		else:
			print "Invalid command:", command
			return 1
	else:
		print __doc__
		return 0
		
	#should never get here
	return 1




if __name__ == "__main__":
	docgen()
	sys.exit(main(sys.argv))
