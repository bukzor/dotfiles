#!/bin/bash

#packages used: ffmpeg, dvdauthor, dvd+rw-tools

#TODO
#somehow do length/size detection and split onto multiple dvd's
#port to VCD, SVCD

#FIXME
#cannot fast-forward through tracks




#Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#run <command>
#runs the command and prints it to stderr
#only prints if $dryrun=true
run(){
echo -n ">>	" > /dev/stderr
if ! $dryrun; then
	echo "$@" | tee /dev/stderr | sh -
	return $?
else
	echo "$@"
	return 0;
fi
}


cleanup(){
if $cleanup && [ "$cleanuplist" ]; then
	echo "#	cleaning up..."
	run rm -R $cleanuplist
fi
}

#Aspect-Ratio detection~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
getaspect(){
#2.350000	=Panavision (235:100)
#2.063888
#1.777777	=Widescreen (16:9)
#1.555555
#1.333333	=Normal     (4:3)

	#parses out `height x 10000 / width` from "ffmpeg -i" 
	#(no decimal numbers in bash)
	aspect=`ffmpeg -i "$1" 2>&1 | grep "Stream\ #0.0"`
	aspect=`echo "$aspect" | sed "s/.* \([1-9][0-9]*\)x\([0-9]*\).*/\10000 \/ \2/"`
	echo ">>	$aspect"
	aspect=$(( $aspect ))	
	if [ $aspect -gt 20639 ]; then
		#dvdauthor does not understand panavision aspect ratio (2.35)
		#we must pad the video into widescreen (16:9)
		aspect="16:9"; 
		pana="-s 720x380 -padtop 50 -padbottom 50";
		echo "#	$1 is Panavision"
	elif [ $aspect -lt 15555 ]; then
		aspect="4:3"
		echo "#	$1 is Normal."
	else
		aspect="16:9"
		echo "#	$1 is Widescreen"
	fi
}

#Encoding~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encode(){
#TODO do a better checking for DVD format
for avi in "$@"; do
	case $avi in
	*.DVD.mpg )
		echo "#	$avi is in DVD format, skipping..."
		mpglist="$mpglist \"$avi\"";;
	* )	
		mpg=`echo "$avi" | sed "s/\.[^.]*$//g"`
		mpg="$mpg.DVD.mpg"
		mpglist="$mpglist \"$mpg\""
		

		if ! [ -f "$mpg" ]; then
			echo "#	Encoding $mpg..."
			if run "ffmpeg -i \"$avi\"  -target $standard-dvd -y \
					-aspect $aspect $pana  $name.temp.DVD.mpg"; then
				run "mv $name.temp.DVD.mpg \"$mpg\""
				cleanuplist="$cleanuplist \"$mpg\""
			else
				echo "#	ffmpeg ERROR WHILE ENCODING \"$avi\""
				exit 1
			fi
		else
			echo "#	$avi already encoded! Skipping..."
		fi;;
	esac
done 
echo "#	Encoding complete!"
}

#Authoring~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
author(){
	if run dvdauthor -o $dvddir --chapters=\"0,5:00,10:00,15:00,20:00,25:00,30:00,35:00,40:00,45:00,50:00,55:00,1:00:00,1:05:00,1:10:00,1:15:00,1:20:00,1:25:00,1:30:00,1:35:00,1:40:00\" -v $standard+$aspect $mpglist; then
		cleanup;
		cleanuplist="\"$dvddir\""
	else
		echo "#	dvdauthor error"
		exit 1;
	fi
	run dvdauthor       -o  "$dvddir"  -T 
}

#ISO creation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
image(){
	if run mkisofs  -dvd-video -o $iso $dvddir; then
		cleanup
		cleanuplist="\"$iso\""
	else
		echo "#	ERROR: mkisofs";
		exit 1;
	fi
	#at this point you can view the iso with:
	#	mplayer dvd:// -dvd-device name.iso
}

#Burn~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
burn(){
	if run growisofs -Z /dev/hdb=$iso -speed=8; then
		cleanup
		cleanuplist=""
		run eject
	else
		echo "#	ERROR: growisofs"
		exit 1
	fi
}

#displays help and exits
showhelp(){
helptext
exit 1
}

helptext(){
echo "Usage: `basename $0` [OPTIONS]... clip1.avi clip2.avi..."				;
echo "Convert each clip to .mpg, author to a folder, convert to .iso image,";
echo "then finally burn to DVD."											;
echo "  -n, --name <base>	base name for created files (recommended)"		;
echo "  -c, --cleanup	will cleanup intermediate files"					;
echo "  -d, --dryrun	will display but not execute commands";
echo "  -h, --help	show more options"										;
echo "";
echo "Target options:";
echo "  -e, --encode	only encode the clips.";
echo "  -a, --author	stop after encoding and authoring the clips";
echo "  -i, --image	only create a .iso image of a DVD, no burning.";
echo "  -b, --burn <iso>	only burn the specified image, no processing";
}

morehelptext(){
echo "";
echo "MORE OPTIONS:";
echo "  -p, --pal	the PAL tv standard will be used (default NTSC)";
echo ""
echo "Aspect options: (automatic aspect detection by default)";
echo "  --norm	clips will be encoded to normal 4:3";
echo "  --wide	clips will be encoded to widescreen 16:9";
echo "  --pana	clips will be encoded to panavision 2.35";
echo "";
echo "Process control options:";
echo "  --no-encode - do not create DVD-compatible clips";
echo "  --no-author - do not create a DVD-format directory tree"
echo "  --no-image  - do notcreate ISO image for burning";
echo "  --no-burn   - disable burning";
}


#Main~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Set defaults
encode="true"
author="true"
image="true"
burn="true"
dryrun="false"
cleanup="false"
standard="ntsc"							#TV standard to use


#Option processing
if ! [ "$1" ]; then
	showhelp
fi

while [ "$#" -gt 0 ]; do
	case $1 in
	-h|--help) 		helptext; morehelptext; exit 0;;
	-d|--dryrun )	echo "Doing a dry-run."; dryrun="true"; shift;;
	-c|--cleanup )	echo "Will cleanup files."; cleanup="true"; shift;;
	-p|--pal ) 		standard="pal"; shift;;
	--norm ) 		echo "Aspect set to Normal."; aspect="4:3"; shift;;
	--wide ) 		echo "Aspect set to Widescreen."; aspect="16:9"; shift;;
	--pana ) 		echo "Aspect set to Panavision."; aspect="16:9"; 
	 				pana="-s 720x380 -padtop 50 -padbottom 50"; shift;;
	--no-encode )	echo "Encoding disabled."; encode="false"; shift;;
	--no-author )	echo "Authoring disabled."; author="false"; shift;;
	--no-image )	echo "Imaging disabled."; image="false"; shift;;
	--no-burn )		echo "Burning disabled."; burn="false"; shift;;
	-e|--encode)
		echo "Will only do encoding."
		burn="false"; author="false"; image="false"; shift;;
	-a|--author)
		echo "Will only author DVD to '$name.dvd/'."
		burn="false"; image="false"; shift;;
	-i|--image)
		echo "Will create but not burn '$name.iso'."
		burn="false"; shift;;
	-b|--burn)
		echo "Will only burn $2."
		iso="$2"; burn; exit 0 ;;
	-n|--name )
		echo "Setting base name to '$2'."
		name="$2"; dvddir="$name.dvd"; iso="$name.iso"; shift 2;;
	-* ) echo "ERROR: option = $1";showhelp;;
	 * ) break;;
	esac
done

shift $(($OPTIND - 1)) #takes the processed options out of $@


#More defaults...
if ! [ "$name" ]; then
	#basename for files to be created
	#strips non-alphanumeric characters and the extension
	name=`echo "$1" | sed -e "s/\.[^.]*$//" -e "s/[^[:alnum:]]/./g"`	
	dvddir="$name.dvd"						#folder to put DVD in
	iso="$name.iso"							#iso file to be created & burned
fi

#main processing
if $encode; then
	if ! [ "$aspect" ]; then
		getaspect "$1";
	fi
	encode "$@"
else
	for mpg in "$@"; do
		mpglist="$mpglist \"$mpg\""
	done
fi
	
if $author; then
	author;
else
	cleanuplist=""
fi

if $image; then
	image ;
else
	cleanuplist=""
fi

if $burn; then
	burn;
fi
exit 0
