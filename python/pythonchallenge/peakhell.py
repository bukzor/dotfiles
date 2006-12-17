#!/usr/bin/python
import pickle

dat = pickle.load(open("peakhell.dat", "r"))
for line in dat:
	string = ""
	for strip in line:
		string += strip[0] * strip[1]
	print string
