#!/bin/bash

INFO_TOKEN=$(echo -n "info${LIVE_SECRET}" | openssl md5 -hex | perl -ne 's/\(stdin\)=\s+// && print')
STATS_TOKEN=$(echo -n "stats${LIVE_SECRET}" | openssl md5 -hex | perl -ne 's/\(stdin\)=\s+// && print')
CTRL_TOKEN=$(echo -n "control${LIVE_SECRET}" | openssl md5 -hex | perl -ne 's/\(stdin\)=\s+// && print')


echo "Stream infos:"
echo "---------------------------------------------------"

echo '{'

echo -n '"stream_url": '
echo "\"rtmp://{ipadress}:{rtmp-port}/pub_${LIVE_SECRET}/{your-stream-name}\","

echo -n '"player_url": '
echo "\"rtmp://{ipadress}:{rtmp-port}/player/{your-stream-name}\","

echo -n '"vod_url": '
echo "\"http://{ipadress}:{http-port}/vod/\","

echo -n '"info_url": '
echo "\"http://{ipadress}:{http-port}/p/${INFO_TOKEN}/info\","

echo -n '"stats_url": '
echo "\"http://{ipadress}:{http-port}/p/${STATS_TOKEN}/stats\","

# hls playlist if hls support is enabled
echo -n '"hls_playlist": '
if [ ! -z "$LIVE_HLS_SUPPORT" ]; then
    echo "\"http://{ipadress}:{http-port}/hls/{your-stream-name}.m3u8\","
else
    echo "\"not available\"",
fi

# control_url for backward compatibility (gui needs it)
echo -n '"control_url": '
echo "\"not available\""

echo '}'