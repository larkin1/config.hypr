#!/usr/bin/env bash
set -uo pipefail
width=50
opt=""

while [ -z "$opt" ]; do
  opt=$(
    printf "search\nconnect existing" | fuzzel --dmenu \
    --prompt="Action: " \
    --placeholder="Choose an option..." \
    --lines=10 \
    --minimal-lines \
    --width=$width
  )
  if [ -z "$opt" ]; then
    notify-send "Bluetooth menu exiting" "Reason: User aborted"
    exit 0
  fi

  case "$opt" in
    search)
      SCAN_DURATION=5
      notify-send "Bluetooth menu status" "Now Scanning..." -t $(($SCAN_DURATION * 1000))
      devices=$(
        bluetoothctl --timeout $SCAN_DURATION scan on 2>/dev/null |
          grep --line-buffered -oP '(?<=\[NEW\] Device )[0-9A-F:]{17} .+' |
          sort -u
      )
      if [ -z "$devices" ]; then
        notify-send "Bluetooth menu error" "No devices found after scan"
        exit 0
      fi
      conn=$(
        echo "$devices" | fuzzel --dmenu \
          --prompt="Select a device: " \
          --placeholder="Select to connect..." \
          --lines=10 \
          --minimal-lines \
          --width=$width
      )
      mac=$(echo "$conn" | awk '{print $1}')

      if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        notify-send "Bluetooth menu" "Device already connected. exiting..."
        exit 0
      fi

      if bluetoothctl connect "$mac"; then
        notify-send "Bluetooth menu" "Connected to $conn"
      else
        notify-send "Bluetooth menu error" "Failed to connect to $conn"
      fi
    ;;
    "connect existing")
      devices=$(
        bluetoothctl devices 2>/dev/null |
          grep -oP '[0-9A-F:]{17} .+' |
          sort -u
      )
      if [ -z "$devices" ]; then
        notify-send "Bluetooth menu error" "No saved devices found"
        exit 0
      fi
      conn=$(
        echo "$devices" | fuzzel --dmenu \
          --prompt="Select a device: " \
          --placeholder="Select to connect..." \
          --lines=10 \
          --minimal-lines \
          --width=$width
      )
      mac=$(echo "$conn" | awk '{print $1}')

      if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        notify-send "Bluetooth menu" "Device already connected. exiting..."
        exit 0
      fi

      notify-send "Bluetooth Menu" "Attempting to connect to $conn"
      if bluetoothctl connect "$mac"; then
        notify-send "Bluetooth menu" "Connected to $conn"
      else
        notify-send "Bluetooth menu error" "Failed to connect to $conn"
      fi

    ;;
    *)
      notify-send "Bluetooth menu error" "Incorrect action"
      opt=""
    ;;
  esac
done
