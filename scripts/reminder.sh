width=50
title=$(printf "" | fuzzel --dmenu --prompt="Title: " --placeholder="Important Meeting" --lines=10 --minimal-lines --width=${width})
if [ -z "$title" ]; then
  dunstify "Reminder Not Set" "Reason: User Quit"
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
    --placeholder="13:55 | now + 10 minutes" \
    --lines=10 \
    --minimal-lines \
    --width=$width \
    --match-mode=exact
}

while :; do
  time=$(get_time)

  if [ -z "$time" ]; then
    dunstify "Reminder Not Set" "Reason: User Quit"
    exit 0
  fi

  if echo ":" | at ${time} 2> /tmp/at_err; then
    break
  else
    err=$(< /tmp/at_err)
    dunstify "Failed to set reminder" "$err"
  fi
done

out=$(echo "dunstify \"${title}\" \"Click to dismiss\" -u critical -t 0; ${action}" | at -v ${time} 2>&1)
time=${out%%$'\n'*}
dunstify "New Reminder Set" "Will occur at ${time}\nExecutes: ${action}"
