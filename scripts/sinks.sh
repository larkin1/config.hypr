#!/usr/bin/env bash
set -uo pipefail
width=50
sinks=$(pactl --format json list sinks | jq -r '.[] | [.index, .properties["device.description"]] | @tsv')

dev=$(
  echo "$sinks" | fuzzel --dmenu \
    --prompt="Select a sink: " \
    --placeholder="Select to set as output..." \
    --lines=10 \
    --minimal-lines \
    --width=$width
)

if [ -z "$dev" ]; then
  notify-send "Sinks exiting" "Reason: User Quit"
  exit 0
fi

idx=$(echo "$dev" | cut -f1)
desc=$(echo "$dev" | cut -f2)

if pactl set-default-sink "$idx"; then
  notify-send "Sinks" "$desc set as default output"
else
  notify-send "Sinks error" "Failed to set device $desc with id $idx as default output device"
  exit 1
fi
