#!/usr/bin/env bash
set -uo pipefail
width=50
opt=""

while [ -z "$opt" ]; do
  opt=$(
    printf "poweroff\nreboot\nsleep\nhibernate" | fuzzel --dmenu \
    --prompt="Action: " \
    --placeholder="Enter an action..." \
    --lines=10 \
    --minimal-lines \
    --width=$width
  )
  if [ -z "$opt" ]; then
    notify-send "Power menu exiting" "Reason: User aborted"
    exit 0
  fi

  case "$opt" in
    poweroff)
      systemctl poweroff
    ;;
    hibernate)
      systemctl hibernate
    ;;
    sleep)
      systemctl sleep
    ;;
    reboot)
      systemctl reboot
    ;;
    *)
      notify-send "Power menu error" "Incorrect action"
      opt=""
    ;;
  esac
done
