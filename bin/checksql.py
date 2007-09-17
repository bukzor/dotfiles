#!/usr/bin/env python

from MySQLdb import connect
from _mysql_exceptions import OperationalError
from time import sleep

def do_connect():
    global cursor
    cursor = connect(\
	host="pdsql.ca.atitech.com", \
	port=3306, user="metricsu", \
	passwd="UM.ic4%").cursor()

cursor = None
pretty = 0
while cursor == None:
    try:
	do_connect()
    except OperationalError, err:
	from sys import stderr
	if err.args[0] == 1040:
	    if pretty == 0:
		stderr.write("Too many connections. Retrying...")
		pretty = 1
	    else:
		stderr.write(".")
	    sleep(1)

    

class SQLprocess:
    def __init__(self, id, user, host, db, type, time, state, query):
	self.id = id
	self.user = user
	self.host = host
	self.db = db
	self.type = type
	self.time = time
	self.state = state
	self.query = str(query)[:700]
    def __cmp__ (self, other):
	return cmp(int(other), self.time)
    def __int__ (self):
	return self.time
    def __str__ (self):
	return "% 5s\t| % 10s | % 32s | %s | % 5s | % 4s | % 7s | %s"\
	    % (self.id, self.user, self.host, self.db, self.type, self.time, \
		self.state, self.query)

showcmd = 'show full processlist'
cursor.execute(showcmd)

#init
old = []
oldest = 0
running = []
long = []
minute = 0
highscore = 0
highscorers = []


pslist=[]
for row in cursor.fetchall():
    s = SQLprocess(*row)
    if s.query != 'None' and s.query != showcmd:
	pslist.append(SQLprocess(*row))
pslist.sort()

if pslist:
    oldest = pslist[0].time

for x in pslist:
    score = 0
    if x.time > 60:
	minute += 1
	score += .5
	if x.time / float(oldest) >= .95:
	    old.append(x)
	    score += .5
    if x.state != 'Locked' and x.type != 'Sleep':
	running.append(x)
	score += 1
    query = x.query.upper()
    ands = query.count(" AND ") 
    ors  = query.count(" OR ")
    score += ands / 30.0
    score += ors / 10.0
   
    if ands + ors > 10 or len(query) > 500:
	long.append(x)
	score += 1
    if score > highscore:
	highscore = score
	highscorers = [x]
    elif score == highscore:
	highscorers.append(x)

print "OLD:", len(old)
for x in old[:10]:
    print x

print "\nRUNNING:", len(running)
for x in running[:10]:
    print x

print "\nLONG:", len(long)
for x in long[:10]:
    print x

if highscore > 1:
    print "\nHIGH SCORERS (at %i points): %i" % (highscore, len(highscorers))
    for x in highscorers:
	print x

print "\n%i queries.." % len(pslist)
print "Oldest has been running for %i seconds." % oldest
print "%i have been running for more than a minute" % minute
print "%i have more than 10 WHERE clauses or more than 500 characters." % len(long)



