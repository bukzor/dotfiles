# Read data from stdin, write data to stdout

A tool's data flows in on stdin and out on stdout. Errors go to stderr. Args
configure behavior; they are not data. This is what lets tools compose: `a | b | c`.
