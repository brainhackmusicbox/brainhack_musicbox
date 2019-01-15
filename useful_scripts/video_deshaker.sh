#/bin/bash

# How to deshake all videos in current folder?

for file in $(ls *.mp4);
	do 
		echo
		echo "=================================================="
		echo "$file: vidstabdetect"
		echo "=================================================="
		echo
		ffmpeg -i $file -vf vidstabdetect=stepsize=6:shakiness=8:accuracy=9 -an -f null -

		echo
		echo "=================================================="
		echo "$file: vidstabtransform"
		echo "=================================================="
		echo

		ffmpeg -i $file -vf vidstabtransform=optzoom=2:smoothing=50 -vcodec libx265 -preset ultrafast -x265-params crf=15 -tune grain -an ${file::-4}_deshake.mp4

		del transforms.trf
done
