#!/bin/bash
while :
do
	i=0
	while [ $i -lt $JOBS ]
	do
		i=$((i+1))
		echo "Starting ffmpeg process $i"
		ffmpeg -y -i ./video/bannerg004.mp4 -c:v vp9 -c:a libvorbis -nostdin ./video/output$i.mkv 2> /dev/null &
	done
	wait
	echo "Finished transcoding"
	sleep 0
done