#!/bin/bash

INFO_TOKEN=$(echo -n "info${LIVE_SECRET}" | openssl md5 -hex | perl -ne 's/\(stdin\)=\s+// && print')
STATS_TOKEN=$(echo -n "stats${LIVE_SECRET}" | openssl md5 -hex | perl -ne 's/\(stdin\)=\s+// && print')
CTRL_TOKEN=$(echo -n "control${LIVE_SECRET}" | openssl md5 -hex | perl -ne 's/\(stdin\)=\s+// && print')


echo "Stream infos:"
echo "---------------------------------------------------"

echo -n "stream_url = "
echo "rtmp://{ipadress}:{port}/pub_${LIVE_SECRET}/{your-stream-name}"

echo -n "player_url = "
echo "rtmp://{ipadress}:{port}/player/{your-stream-name}"

echo -n "hls_playlist = "
echo "http://{ipadress}:{port}/hls/{your-stream-name}.m3u8"

echo -n "vod_url = "
echo "http://{ipadress}:{port}/vod/"

echo -n "info_url = "
echo "http://{ipadress}:{port}/p/${INFO_TOKEN}/info"

echo -n "stats_url = "
echo "http://{ipadress}:{port}/p/${STATS_TOKEN}/stats"

echo -n "control_url = "
echo "http://{ipadress}:{port}/p/${CTRL_TOKEN}/control"
