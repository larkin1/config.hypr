hl.on("hyprland.start", function ()
  local cmds = {
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland HYPRLAND_INSTANCE_SIGNATURE",
    "hyprpaper",
    "~/.config/waybar/scripts/rgb-cycle.sh & waybar",
    "hypridle",
    "wl-paste --watch cliphist store",
    "systemctl --user start hyprpolkitagent.service",
  }
  for _, cmd in ipairs(cmds) do
    hl.exec_cmd(cmd)
  end
end)
