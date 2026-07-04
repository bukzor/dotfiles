# Double-dash, not em dash

In file content, write `--`, never an em dash (U+2014). Em dash is not a
thing any human would type; it marks text as machine-generated and can't
be grepped from a keyboard. Leave existing em dashes alone -- converting
them is churn.
