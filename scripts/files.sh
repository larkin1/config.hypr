#!/usr/bin/env bash
set -uo pipefail
width=50

file="$(fd . "/" --type f -H \
  -E '.git' \
  -E 'node_modules' \
  -E '.cache' \
  -E 'proc' \
  -E 'sys' \
  -E 'dev' \
  -E 'run' | fuzzel --dmenu \
  --prompt="File: " \
  --placeholder=\"$HOME/file\" \
  --lines=5 \
  --minimal-lines \
  --search="${HOME}/")"

if [ -z "$file" ]; then
  notify-send "File menu exiting" "Reason: User aborted"
  exit 0
fi

if ! [ -e "$file" ]; then
  notify-send "File menu exiting" "Reason: Invalid file name"
  exit 0
fi

mime="$(xdg-mime query filetype "$file")"
default_app="$(xdg-mime query default "$mime")"

choice="$({
  [[ -n "$default_app" ]] && echo "  Default (${default_app%.desktop})"
  echo "  Copy file"
  echo "  Copy path"
  echo "  Open dir"
  echo "  Open terminal in dir"
  echo "  Delete"
  gio mime "$mime" 2>/dev/null \
    | grep -oP '\t\K\S+\.desktop' \
    | grep -v "^${default_app}$" \
    | sort -u \
    | while read -r desktop; do
        label="$(grep -m1 '^Name=' \
          "/usr/share/applications/$desktop" \
          "$HOME/.local/share/applications/$desktop" 2>/dev/null \
          | head -n1 | cut -d= -f2)"
        [[ -n "$label" ]] && echo "  $label ($desktop)"
      done
} | fuzzel --dmenu \
    --prompt="Open with: " \
    --placeholder="Select a program or action" \
    --lines=15 \
    --minimal-lines \
    --width=$width
)"

if [ -z "$choice" ]; then
  xdg-open "$file"
fi

case $choice in
  *"Default"*)
    xdg-open "$file"
    ;;
  *"Copy path"*)
    wl-copy "$file"
    notify-send "File menu" "Path copied to clipboard"
    ;;
  *"Copy file"*)
    printf 'file://%s' "$file" | wl-copy --type text/uri-list
    notify-send "File menu" "File copied to clipboard"
    ;;
  *"Open dir"*)
    xdg-open "$(dirname "$file")"
    ;;
  *"Open terminal in dir"*)
    ghostty --working-directory="$(dirname "$file")"
    ;;
  *"Delete"*)
    confirm=$(printf "N\nY" | fuzzel --dmenu \
      --prompt="Are you sure?: " \
      --placeholder="y/N" \
      --lines=5 \
      --minimal-lines \
      --width=$width
    )

    case $confirm in
      [Yy])
        rm $file
        notify-send "File menu" "Deleted file: $file"
        ;;
      *)
        notify-send "File menu" "File not removed"
        ;;
    esac
    ;;
  *)
    desktop="$(echo "$choice" | grep -oP '\(\K[^)]+\.desktop')"
    gtk-launch "$desktop" "$file"
    ;;
esac
