#!/bin/sh

FFMPEG_LOG="/home/pi/ffmpeg_stream.log"
STREAM_LOG="/home/pi/stream.log"

if ! pgrep -x "ffmpeg" > /dev/null
then
        echo "FFmpeg is no running"
	bash /home/pi/ffmpeg.sh &
	echo "FFmpeg started."

fi
sleep 10

while true; do
    frameA=$(tail -n 1 "$FFMPEG_LOG" | sed -nr 's/.frame=(.*)fps./\1/p')
    echo "Current frame count: $frameA"

    sleep 4

    frameB=$(tail -n 1 "$FFMPEG_LOG" | sed -nr 's/.frame=(.*)fps./\1/p')
    echo "New frame count: $frameB"

    if [ "$frameA" = "$frameB" ]; then
        echo "Stream has hung."
        printf "%s - Stream has hung\n" "$(date)" >> "$STREAM_LOG"

        pkill ffmpeg
        echo "Killed ffmpeg..."
        printf "%s - Killed ffmpeg\n" "$(date)" >> "$STREAM_LOG"

        bash /home/pi/ffmpeg.sh &
        echo "Started ffmpeg..."
        printf "%s - Started ffmpeg\n" "$(date)" >> "$STREAM_LOG"
    else
        echo "Stream looks ok."
    fi

    sleep 2
done
