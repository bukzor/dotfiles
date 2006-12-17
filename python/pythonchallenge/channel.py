#!/usr/bin/python
import zipfile

zip = zipfile.ZipFile("channel.zip")
nothing = "Next nothing is "
text = nothing + "90052"

s = ""
while nothing in text:
	nextfile = text.split()[-1] + ".txt"
	s += zip.NameToInfo[nextfile].comment
	text = zip.read(nextfile)
print s
