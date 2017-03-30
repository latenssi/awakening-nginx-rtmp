#!/bin/bash

set -eo pipefail

echo "[awakening-nginx-rtmp] starting..."

if [ -z "$ETCD_URL" ]; then

    if ! compgen -A variable | grep LIVE_VARIANTS >/dev/null; then
       echo "[awakening-nginx-rtmp] disable HLS support because LIVE_VARIANTS_* are not set"
       unset LIVE_HLS_SUPPORT
    else
        echo "[awakening-nginx-rtmp] enabling HLS support because LIVE_VARIANTS_* were provided"
        export LIVE_HLS_SUPPORT=1
    fi

    if [ ! -z "$PUBLISH_SECRET" ]; then
        echo "[awakening-nginx-rtmp] PUBLISH_SECRET is deprecated, use LIVE_SECRET instead"
        export LIVE_SECRET="$PUBLISH_SECRET"
    fi

    if [ ! -z "$CORS_HTTP_ORIGIN" ]; then
        echo "[awakening-nginx-rtmp] CORS_HTTP_ORIGIN is deprecated, use LIVE_CORS instead"
        export LIVE_CORS="$CORS_HTTP_ORIGIN"
    fi

    echo "[awakening-nginx-rtmp] rendering configuration from environment variables..."
    confd -onetime -backend env

else

    until confd -onetime -node $ETCD_URL; do
        echo "[awakening-nginx-rtmp] waiting for etcd to populate configuration variables..."
        sleep 5
    done
    echo "[awakening-nginx-rtmp] monitoring etcd for changes..."
    confd -interval 10 -node $ETCD_URL &
fi

echo "The server is now ready to accept your rtmp stream !"

/usr/sbin/show-streaming-infos.sh

exec $@
