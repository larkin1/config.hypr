local M = require("lua.vars")

-- program shortcuts
hl.bind(M.mainMod .. " + Q", hl.dsp.exec_cmd(M.terminal))
hl.bind(M.mainMod .. " + E", hl.dsp.exec_cmd(M.fileManager))
hl.bind(M.mainMod .. " + R", hl.dsp.exec_cmd(M.runMenu))

-- clipboard
hl.bind(M.mainMod .. " + S", hl.dsp.exec_cmd("grim -g \"$(slurp -d)\" - | wl-copy -t image/png"))
hl.bind(M.mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))

-- window commands
hl.bind(M.mainMod .. " + C", hl.dsp.window.close())
hl.bind(M.mainMod .. " + SHIFT + C", hl.dsp.window.kill())
hl.bind(M.mainMod .. " + B", hl.dsp.window.float({ action = "toggle" }))
hl.bind(M.mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- resizing windows
hl.bind(M.mainMod .. " + I", hl.dsp.window.resize({ x = 0, y = 50 }), { repeating = true })
hl.bind(M.mainMod .. " + O", hl.dsp.window.resize({ x = 0, y = -50 }), { repeating = true })
hl.bind(M.mainMod .. " + P", hl.dsp.window.resize({ x = 50, y = 0 }), { repeating = true })
hl.bind(M.mainMod .. " + U", hl.dsp.window.resize({ x = -50, y = 0 }), { repeating = true })

-- move between windows
hl.bind(M.mainMod .. " + H", hl.dsp.focus({ direction = "l" }), { repeating = true })
hl.bind(M.mainMod .. " + L", hl.dsp.focus({ direction = "r" }), { repeating = true })
hl.bind(M.mainMod .. " + K", hl.dsp.focus({ direction = "u" }), { repeating = true })
hl.bind(M.mainMod .. " + J", hl.dsp.focus({ direction = "d" }), { repeating = true })

-- move windows
hl.bind(M.mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind(M.mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind(M.mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(M.mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { repeating = true })

-- workspace commands
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(M.mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind(M.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
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

