#!/bin/bash

#exec > /tmp/debug-$$.log

# functions
on_die ()
{
    echo "trapped signal $$"
    # kill all children
    pkill -KILL -P $$
}

smallest () 
{
    [ $2 -gt $1 ] && echo $1 || echo $2

}

bigest ()
{
    [ $1 -gt $2 ] && echo $1 || echo $2    
}


# sanity checks
if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ]; then
    echo "Usage: $0 <video bitrate in kbps> <audio bitrate in kbps> <source> <destination>"
    echo ""
    echo "ex: $0 500 128 rtmp://localhost/stream1 rtmp://localhost/stream2"
    exit 0
fi

# calculating the values
VIDEOBR=${1:-500}
AUDIOBR=${2:-500}
MINRATE=$(bigest ${VIDEOBR} ${AUDIOBR})
MAXRATE=$(bigest ${VIDEOBR} ${AUDIOBR})
BUFSIZE=$( echo "(${VIDEOBR} + ${AUDIOBR}) * 2" | bc )
SRC=${3}
DST=${4}

CMD="avconv -i ${SRC} -f flv -crf 30 -preset ultrafast -strict experimental -ar 44100 -r 25 -c:v libx264 -x264-params 'nal-hrd=cbr' -b:v ${VIDEOBR}k -c:a copy -b:a ${AUDIOBR}k -minrate ${MINRATE}k -maxrate ${MAXRATE}k -bufsize ${BUFSIZE}k ${DST}"

echo "Running .... $CMD"

trap 'on_die' TERM
exec $CMD &
wait
