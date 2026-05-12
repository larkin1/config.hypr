local M = require("hyprland.vars")

hl.bind(M.mainMod .. " + Q", hl.dsp.exec_cmd(M.terminal))
hl.bind(M.mainMod .. " + C", hl.dsp.window.close(hl.get_active_window()))
