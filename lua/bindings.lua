local M = require("lua.vars")

-- program shortcuts
hl.bind(M.mainMod .. " + Q", hl.dsp.exec_cmd(M.terminal))
hl.bind(M.mainMod .. " + E", hl.dsp.exec_cmd(M.fileManager))
hl.bind(M.mainMod .. " + R", hl.dsp.exec_cmd(M.runMenu))
hl.bind(M.mainMod .. " + SEMICOLON", hl.dsp.exec_cmd('BEMOJI_PICKER_CMD="$HOME/.config/hypr/scripts/fuzzel-emoji-picker.sh" bemoji'))
hl.bind(M.mainMod .. " + GRAVE", hl.dsp.exec_cmd('$HOME/.config/hypr/scripts/launcher.sh'))

-- clipboard
-- hl.bind(M.mainMod .. " + S", hl.dsp.exec_cmd("grim -g \"$(slurp -d)\" - | wl-copy -t image/png"))
local cmd = [=[grim -g "$(slurp)" - | wl-copy -t image/png && action=$(dunstify "Screenshot taken" "Click to edit" -t 10000 --action="edit,Edit") && [[ "$action" == "edit" ]] && wl-paste | satty --copy-command wl-copy --filename - --output-filename "$HOME/Pictures/Screenshots/$(date '+%Y%m%d-%H%M%S').png"]=]
hl.bind(M.mainMod .. " + S", hl.dsp.exec_cmd(cmd))
hl.bind(M.mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

-- window commands
hl.bind(M.mainMod .. " + C", hl.dsp.window.close())
hl.bind(M.mainMod .. " + SHIFT + C", hl.dsp.window.kill())
hl.bind(M.mainMod .. " + B", hl.dsp.window.float({ action = "toggle" }))
hl.bind(M.mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))


-- resizing windows
hl.bind(M.mainMod .. " + U", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind(M.mainMod .. " + I", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(M.mainMod .. " + O", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(M.mainMod .. " + Y", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })

-- keys and directios for moving
local dirkeys = {"H", "J", "K", "L"}
local altdirkeys = {"Y", "U", "I", "O"}
local dirs = {"l", "d", "u", "r"}

-- move between windows
for i, key in ipairs(dirkeys) do
  hl.bind(M.mainMod .. " + " .. key, hl.dsp.focus({ direction = dirs[i] }), { repeating = true })
end

-- move windows
for i, key in ipairs(dirkeys) do
  hl.bind(M.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dirs[i] }), { repeating = true })
end

-- workspace commands
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(M.mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(M.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- swapping monitors
local function swap_with_monitor(dir)
    return function()
        local active = assert(hl.get_active_monitor()) --[[@as HL.Monitor]]
        local monitors = hl.get_monitors()
        if #monitors == 2 then
            local other = monitors[1].name == active.name and monitors[2] or monitors[1]
            hl.dispatch(hl.dsp.workspace.swap_monitors({ monitor1 = active.name, monitor2 = other.name }))
            return
        end
        local offset = {
            x = active.x + (dir == "r" and active.width  or dir == "l" and -1 or 0),
            y = active.y + (dir == "d" and active.height or dir == "u" and -1 or 0),
        }
        local other = hl.get_monitor_at(offset.x, active.y + (active.height / 2))
        if other then
            hl.dispatch(hl.dsp.workspace.swap_monitors({ monitor1 = active.name, monitor2 = other.name }))
        end
    end
end

for i, key in ipairs(dirkeys) do
  hl.bind(M.mainMod .. " + CTRL + " .. key, swap_with_monitor(dirs[i]))
end

-- moving workspaces
for i, key in ipairs(altdirkeys) do
  hl.bind(M.mainMod .. " + CTRL + " .. key, hl.dsp.workspace.move({ monitor = dirs[i] }))
end

-- mouse commands
hl.bind(M.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(M.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
