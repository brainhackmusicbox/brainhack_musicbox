#/bin/bash

# How to deshake all videos in current folder?

for file in $(ls *.mp4);
	do 
		echo
		echo "=================================================="
		echo "$file: vidstabdetect"
		echo "=================================================="
		echo
		ffmpeg -i $file -vf vidstabdetect=shakiness=10:accuracy=10 -an -f null -

		echo
		echo "=================================================="
		echo "$file: vidstabtransform"
		echo "=================================================="
		echo

		ffmpeg -i $file -vf vidstabtransform=zoom=5:smoothing=50 -vcodec libx265 -x265-params crf=15 -preset ultrafast -tune grain -an ${file::-4}_deshake.mp4

		del transforms.trf
done
