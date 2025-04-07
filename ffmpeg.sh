#!/bin/bash
UUID=$(cat /home/pi/legacy_uuid_get_script/legacy_uid.txt)
RTMP_URL="rtmp://10.92.0.18:1935/$UUID"
LOG_FILE="/home/pi/ffmpeg_stream.log" 
echo "$RTMP_URL"
echo "Starting FFmpeg stream on Linux..." >>"$LOG_FILE"
ffmpeg -f v4l2 -framerate 90 -video_size 1280x720 -input_format mjpeg -i /dev/video0 \
-c:v libx264 -b:v 32M -preset ultrafast -tune zerolatency -x264-params 'keyint=60:min-keyint=30' \
-crf 28 -an -f flv "$RTMP_URL" >>"$LOG_FILE" 2>&1
