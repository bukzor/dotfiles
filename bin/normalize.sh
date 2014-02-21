

function break_lists() {
	echo "$@" | xargs sed -ri '
		s/^\s+//;
		/^$/d;
		s/\.buck[^.]+\.dev\.yelp/.buck.dev.yelp/g;
		s/2010[0-9]{8,}/2010101010101010/g;
		s/[0-9a-f]{16}/$HEX/g;
		s/\$HEX[0-9a-f]+/$HEX/g;
		s/[0-9A-F]{16}/$YUV/g;
		s/<input type="hidden" name="context" value="[^"]+">/<input type="hidden" name="context" value="">/;
		s/>\s*(\S)/>\n\1/g;
		s/(\S)\s*</\1\n</g;
		s/([]},{[])\s*(\S)/\1\n\2/g;
	'
}

break_lists "$@"
break_lists "$@"
break_lists "$@"

#echo "$@" | xargs -n1 | xargs --replace tidy -indent --new-blocklevel-tags fb:connect-bar -o {} {}

