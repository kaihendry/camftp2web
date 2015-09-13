#!/bin/bash

sdir=${sdir:-/home} # source directory
wdir=${wdir:-/var/www/cam} # web directory

test -d $sdir || exit

np="$(mktemp -d)/copy-$$"
mkfifo "$np" || exit

inotifywait -r -m -e CLOSE_WRITE "$sdir" > "$np" & ipid=$!

trap "kill $ipid; rm -f $np" EXIT

while read -r dir _ fn
do

	od=$wdir/$(date +%Y-%m-%d) # output directory with date
	mkdir -p $od || true

	case "${fn##*.}" in

	mkv)
		if FFREPORT=file=/tmp/htmlvideo.log:level=32 ffmpeg -v panic -i $dir/$fn -c:a copy -c:v copy $od/$(basename $fn mkv)mp4 < /dev/null
		then
			rm -vf $dir/$fn
		fi
		;;

	jpg)
		ofn=$od/$fn # output file name
		echo $fn is an image, moving to $ofn
		mv $dir/$fn $ofn && chmod a+r $ofn
		;;

	*)
		echo Unknown type: $dir/$fn
		;;

	esac

done < "$np"
