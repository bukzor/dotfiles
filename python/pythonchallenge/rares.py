#/usr/bin/python

fd = open("rares.dat", "r")

d = {}
count = 0
for line in fd:
	for l in line:
		if l in d.keys():
			d[l] += 1
		else:
			d[l] = 1
		count += 1


for k in d.keys():
	if d[k]*100/count > 0:
		d.pop(k)

fd = open("rares.dat", "r")
t=""
for line in fd:
	for l in line:
		if l in d.keys():
			t+=l


print t
