#!/bin/sh

confdir="`dirname "$0"`/../config/"
. ${confdir}/defaults.sh
. ${confdir}/config.sh

# Please provide a background in $confdir/background.raw
# it's generated by using
# ffmpeg -i background.png -c:v rawvideo -pix_fmt:v yuv420p -c:v rawvideo -pix_fmt yuv420p -frames 1 -f rawvideo background.raw
# thanks to felixs on hackint/#voctomix

#ffmpeg -y -i /opt/config/background.png -c:v rawvideo -pix_fmt:v yuv420p -c:v rawvideo -pix_fmt yuv420p -frames 1 -f rawvideo /opt/config/background.raw

ffmpeg -v error -re -y -f image2 -loop 1 -pixel_format yuv420p \
	-framerate ${FRAMERATE} -video_size ${WIDTH}x${HEIGHT} \
	-i $confdir/slide.raw \
	-f lavfi -i anullsrc=channel_layout=stereo:sample_rate=${AUDIORATE} \
	-c:v rawvideo -pix_fmt yuv420p \
	-c:a pcm_s16le \
	-f matroska \
	tcp://localhost:10001
