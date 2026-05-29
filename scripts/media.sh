#!/usr/bin/env bash
set -uo pipefail
width=50

player=$(
  printf "$(playerctl -l)\nvolume\npause-all\nplay-all" | fuzzel --dmenu \
  --prompt="Player: " \
  --placeholder="Select a player to use or action..." \
  --lines=10 \
  --minimal-lines \
  --width=$width
)

if [ -z "$player" ]; then
  notify-send "Media menu exiting" "Reason: User aborted"
  exit 0
fi

case "$player" in
  pause-all)
    playerctl -a pause
  ;;
  play-all)
    playerctl -a play
  ;;
  volume)
    vol=$(
      printf "" | fuzzel --dmenu \
        --prompt="Volume level: " \
        --placeholder="10 | +10 | -10dB | 0.5" \
        --lines=10 \
        --minimal-lines \
        --width=$width
    )
    if [ -z "$vol" ]; then
      notify-send "Media menu exiting" "Reason: User aborted"
      exit 0
    fi

    if [[ $vol =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]; then
      if [[ $vol == [+-]* ]] || awk "BEGIN { exit !($vol > 1) }"; then
        vol="${vol}%"
      fi
    fi

    if pactl set-sink-volume @DEFAULT_SINK@ "$vol"; then
      notify-send "Media menu" "Volume set"
    else
      notify-send "Media menu exiting" "Reason: Invalid volume set"
      exit 1
    fi
  ;;
  *)
    opt=$(
      printf "play\npause\nvolume\nnext\nprev" | fuzzel --dmenu \
      --prompt="Action: " \
      --placeholder="Enter an action..." \
      --lines=10 \
      --minimal-lines \
      --width=$width
    )
    if [ -z "$opt" ]; then
      notify-send "Media menu exiting" "Reason: User aborted"
      exit 0
    fi
    case "$opt" in
      play)
        playerctl -p "$player" play
      ;;
      pause)
        playerctl -p "$player" pause
      ;;
      volume)
        vol=$(
          printf "" | fuzzel --dmenu \
            --prompt="Volume level: " \
            --placeholder="0-100" \
            --lines=10 \
            --minimal-lines \
            --width=$width
        )
        if [ -z "$vol" ]; then
          notify-send "Media menu exiting" "Reason: User aborted"
          exit 0
        fi

        vol=$(awk "BEGIN { printf \"%.2f\", $vol / 100 }")

        if playerctl -p "$player" volume "$vol"; then
          notify-send "Media menu" "Volume set"
        else
          notify-send "Media menu exiting" "Reason: Invalid volume set"
        fi
      ;;
      next)
        playerctl -p "$player" next
      ;;
      previous)
        playerctl -p "$player" previous
      ;;
      *)
        notify-send "Media menu error" "Incorrect action"
        exit 1
      ;;
    esac
  ;;
esac
