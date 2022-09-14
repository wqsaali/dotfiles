#!/usr/bin/env bash

# notify-send -u critical -t 10000 -- 'LOCKING screen now'

SEC=5
[ $# -eq 1 ] && SEC=$1
FRAMES=100
SLEEP=$(echo "$SEC" / $FRAMES | bc -l)

trap "xcalib -clear" EXIT

sleep 0.1

LAST_IDLE=$(xprintidle)
for ((i = 1; i <= FRAMES; i++)); do
  NEW_IDLE=$(xprintidle)
  if [ "$LAST_IDLE" -gt "$NEW_IDLE" ]; then
    exit 0
  fi
  LAST_IDLE=$NEW_IDLE
  xcalib -co 95 -a
  sleep "$SLEEP"
done

# dm-tool lock
xset dpms force off
