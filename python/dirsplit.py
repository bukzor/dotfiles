#!/usr/bin/python
#Future improvements:
#select starting volume number from commandline
#handle "=" and "\" in filenames completely
#handle super long filenames

import os.path
import sys

#print os.path.getsize(sys.argv[1])
class Chunk:
	#attempts to get splitting size from command line
	max = 4700000000 #DVD = 4.7GB
	def __init__(self):
		#TODO make this variable from commandline
		self.num = 11
		self.__start()
	def printme(self):
		print "Chunk", self.num, ":", #chunkfiles
		print "Size:", self.size
		print "Waste:", \
			round(1 - float(self.size) / float(Chunk.max), 4)*100, "%\n"
	def __start(self):
		self.size = 0
		self.out = open("vol_%03d.list" % self.num, 'w')
	def __restart(self):
		self.printme()
		self.out.close()
		self.num += 1
		self.__start()
	def add_file(self, inpath):
		"adds the file to either the current chunk, or the next"
		if "=" in inpath:
			outpath = inpath.replace("=","-")
			print "Renaming", inpath, "to", outpath
			print "..."
		else:
			outpath = inpath

		try:
			#4096 = block size, 207 = max path length
			size = max(os.path.getsize(inpath), 4096) + 207
		except OSError:
			#this is the case of bad soflinks
			size = 4303

		if size > Chunk.max:
			print "File \"" + inpath + "\"too big. Size =", size
			sys.exit(1)
		elif self.size + size > Chunk.max:
			#start new chunk
			self.__restart()
		self.size += size
		self.out.write(outpath + "=" + inpath + "\n")

	


chunk = Chunk()
for start in sys.argv[1:]:
	for root, dirs, files in os.walk(start):
		files.sort()
		dirs.sort()
		for file in files:
			chunk.add_file(os.path.join(root, file))
		#symbolic links can be listed as directories
		for dir in dirs:
			dirpath = os.path.join(root, dir)
			if os.path.islink(dirpath):
				chunk.add_file(dirpath)
chunk.printme()

