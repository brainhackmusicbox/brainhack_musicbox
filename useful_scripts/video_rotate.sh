#/bin/bash

# How to rotate all *.mp4 in current folder (except with no rotate field)

for file in $(ls MOV*.mp4);
	do
	if [ "$(ffprobe $file 2>&1| grep rotate)" == "" ];
	then
		echo "=================================================================="
		echo "$file: already correct orientation"
		echo "=================================================================="
		cp $file ${file#*_}
	else
		echo "=================================================================="
		echo "$file: rotation"
		echo "=================================================================="
		#ffmpeg -y -i $file -vf "transpose=2" -an -c:v libx265 -preset ultrafast -x265-params crf=18 ${file%.*}_rotated.mp4
		ffmpeg -y -i $file -vf "transpose=2" -an -c:v libx265 -preset ultrafast -x265-params crf=15 -tune grain ${file#*_}

	fi
	done
