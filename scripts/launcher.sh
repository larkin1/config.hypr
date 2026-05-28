# set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
width=50
opt=""

while [ -z "$opt" ]; do
  opt=$(
    printf "reminder\npower\nbluetooth" | fuzzel --dmenu \
    --prompt="Action: " \
    --placeholder="Enter an action..." \
    --lines=10 \
    --minimal-lines \
    --width=$width
  )
  if [ -z "$opt" ]; then
    notify-send "Run menu exiting" "Reason: User aborted"
    exit 0
  fi

  case "$opt" in
    reminder)
      "$SCRIPT_DIR/reminder.sh"
    ;;
    power)
      "$SCRIPT_DIR/power.sh"
    ;;
    bluetooth)
      "$SCRIPT_DIR/bluetooth.sh"
    ;;
    *)
      notify-send "Run menu error" "Incorrect action"
      opt=""
    ;;
  esac
done
