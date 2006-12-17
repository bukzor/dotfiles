#!/usr/bin/python

a = ord("a")
z = ord("z")
#s = "http://www.pythonchallenge.com/pc/def/map.html"
s = "g fmnc wms bgblr rpylqjyrc gr zw fylb. rfyrq ufyr amknsrcpq ypc dmp. bmgle gr gl zw fylb gq glcddgagclr ylb rfyr'q ufw rfgq rcvr gq qm jmle. sqgle qrpgle.kyicrpylq() gq pcamkkclbcb. lmu ynnjw ml rfc spj."


t = ""
for l in s:
	l = ord(l)
	if l >= a and l <= z:
		l = (l + 2 - a) % 26 + a	
	t += chr(l)
print t
