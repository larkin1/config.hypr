width=50
title=$(printf "" | fuzzel --dmenu --prompt="Title: " --placeholder="Important Meeting" --lines=10 --minimal-lines --width=${width})
if [ $? -ne 0 ] || [ -z "$title" ]; then
  dunstify "Reminder Not Set" "Reason: User Quit"
  exit 0
fi

opt=$(printf "file\nurl\ncommand" | fuzzel --dmenu --prompt="Action: " --placeholder="file | url | command" --lines=10 --minimal-lines --width=$width)
if [ $? -ne 0 ] || [ -z "$opt" ]; then
  action=:
  opt="pass"
fi

case "$opt" in
  file) 
    action="xdg-open \"$(fd . "/" --type f | fuzzel --dmenu \
      --delayed-filter-limit=500 \
      --hide-before-typing \
      --prompt="File: " \
      --placeholder="$HOME/file" \
      --lines=5 \
      --minimal-lines \
      --width=$width \
      --search="$HOME"
    )\""
  ;;
  url) 
    action="xdg-open \"$(printf "" | fuzzel --dmenu \
      --prompt="Url: " \
      --placeholder="https://... (strips double https:// strings)" \
      --lines=5 \
      --minimal-lines \
      --width=$width \
      --search="https://"
    )\""
    if [[ $action == xdg-open\ https://https://* ]]; then
      action="xdg-open https://${action#xdg-open https://https://}"
    fi
  ;;
  pass)
    action=:
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

time=$(printf "" | fuzzel --dmenu --prompt="When: " --placeholder="13:55 | now + 10 minutes" --lines=10 --minimal-lines --width=$width --match-mode=exact)
if [ $? -ne 0 ] || [ -z "$time" ]; then
  dunstify "Reminder Not Set" "Reason: User Quit"
  exit 0
fi


out=$(echo "dunstify \"${title}\" \"Click to dismiss\" -u critical -t 0; ${action}" | at -v ${time} 2>&1)
time=${out%%$'\n'*}
dunstify "New Reminder Set" "Will occur at ${time}\nExecutes: ${action}"
