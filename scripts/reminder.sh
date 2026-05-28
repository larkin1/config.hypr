width=50
title=$(printf "" | fuzzel --dmenu --prompt="Title: " --placeholder="Important Meeting" --lines=10 --minimal-lines --width=${width})
if [ -z "$title" ]; then
  notify-send "Reminder Not Set" "Reason: User Quit"
  exit 0
fi

opt=$(printf "file\nurl\ncommand\nworkspace" | fuzzel --dmenu --prompt="Action: " --placeholder="file | url | command" --lines=10 --minimal-lines --width=$width)
if [ -z "$opt" ]; then
  action=:
  opt="pass"
fi

case "$opt" in
  file) 
    file="$(fd . "/" --type f | fuzzel --dmenu \
      --delayed-filter-limit=500 \
      --hide-before-typing \
      --prompt="File: " \
      --placeholder=\"$HOME/file\" \
      --lines=5 \
      --minimal-lines \
      --width=$width \
      --search="${HOME}/")"
    action="xdg-open \"${file}\""
  ;;
  url) 
    url="$(printf "" | fuzzel --dmenu \
      --prompt="Url: " \
      --placeholder="https://... (strips double https:// strings)" \
      --lines=5 \
      --minimal-lines \
      --width=$width \
      --search="https://"
    )"
    action="xdg-open \"${url}\""
    if [[ $action == xdg-open\ https://https://* ]]; then
      action="xdg-open https://${action#xdg-open https://https://}"
    fi
  ;;
  pass)
    action=:
  ;;
  workspace) 
    wspace=$(seq 10 | fuzzel --dmenu \
      --prompt="Workspace: " \
      --placeholder="Workspace to focus..." \
      --lines=10 \
      --minimal-lines \
      --width=$width \
    )
    action="hyprctl dispatch 'hl.dsp.focus({ workspace=${wspace} })'"
  ;;
  *) action=$(printf "" | fuzzel --dmenu \
      --prompt="Command: " \
      --placeholder="Command to execute..." \
      --lines=5 \
      --minimal-lines \
      --width=$width \
    )
  ;;
esac

get_time() {
  printf "" | fuzzel \
    --dmenu \
    --prompt="When: " \
    --placeholder="hh:mm | yyyy-mm-dd hh:mm | 10h/m" \
    --lines=10 \
    --minimal-lines \
    --width=$width \
    --match-mode=exact
}

span_to_phrase() {
  case $1 in
    *s) printf '%ssec' "${1%s}" ;;
    *m) printf '%smin' "${1%m}" ;;
    *h) printf '%shour' "${1%h}" ;;
    *) return 1 ;;
  esac
}

while :; do
  rawtime=$(get_time)
  if [ -z "$rawtime" ]; then
    notify-send "Reminder Not Set" "Reason: User Quit"
    exit 0
  fi
  if systemd-analyze calendar "$rawtime" >/dev/null 2>&1; then
    if [[ $rawtime =~ ^[0-9]{2}:[0-9]{2}(:[0-9]{2})?$ ]]; then
      pretty_time=$(date -d "$rawtime" '+%F %T')
      if [[ $(date -d "$pretty_time" +%s) -le $(date +%s) ]]; then
        pretty_time=$(date -d "tomorrow $rawtime" '+%F %T')
      fi
      time="--on-calendar=$pretty_time"
    else
      pretty_time=$(date -d "$rawtime" '+%F %T')
      time="--on-calendar=$rawtime"
    fi
    break
  elif systemd-analyze timespan "$rawtime" >/dev/null 2>&1; then
    time="--on-active=$rawtime"
    pretty_time=$(date -d "$(span_to_phrase "$rawtime")" '+%F %T')
    break
  else
    notify-send "Failed to set reminder" "Invalid format: $rawtime"
  fi
done

cmd=$(printf 'notify-send %q %q -u critical -t 0; %s' \
  "$title" "Click to dismiss" "$action")

if systemd-run --user "$time" bash -lc "$cmd" >/dev/null 2>&1; then
  notify-send "New Reminder Set" "Will occur at ${pretty_time}\nExecutes: ${action}"
else
  notify-send "Failed to set reminder" "systemd-run failed"
fi
