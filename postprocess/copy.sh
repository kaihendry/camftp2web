#!/bin/bash

DIR=/srv/ftp/888/C1_00626E587B70
DEST=/srv/www/nuc.local
np="$(mktemp -d)/copy-$$"
mkfifo "$np" || exit

inotifywait -r -m -e CLOSE_WRITE "$DIR" > "$np" & ipid=$!

trap "kill $ipid; rm -f $np" EXIT

while read -r dir event filename
do
	D=$DEST/$(date +%Y-%m-%d)
	mkdir -p $D || true
	case "${filename##*.}" in
	mkv)
		echo $filename is a movie
		T=$D/$(basename $filename .mkv).mp4
		ffmpeg -i $DIR/record/$filename -movflags +faststart -pix_fmt yuv420p -c:v libx264 -profile:v high -level 4.2 $T
		chmod a+r $T
		ln -sf $T $DIR/last.mp4
		rm -vf $DIR/record/$filename
		;;
	jpg)
		echo $filename is an image
		T=$D/$(basename $filename)
		mv $DIR/snap/$filename $T
		chmod a+r $T
		jpegoptim $T
		ln -sf $T $DIR/last.jpg
		;;
	*)
		echo Unknown $filename
		;;
	esac
	
done < "$np"
