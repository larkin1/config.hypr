-- ignore maximize requests
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- fix some dragging issues with XWayland
hl.window_rule({
  name = "fix-drags",
  no_focus = true,
  match = {
    class = "^$",
    title = "^$",
    xwayland = 1,
    float = 1,
    fullscreen = 0,
    pin = 0,
  }
})

-- make some windows transparent
hl.window_rule({
  name = "thunar-trans",
  opacity = 0.75,
  match = { class = "^(thunar)$" },
})

hl.window_rule({
  name = "ghostty-trans",
  opacity = 0.75,
  match = { class = "^(com.mitchellh.ghostty)$" },
})

hl.window_rule({
  name = "rofi-trans",
  opacity = 0.75,
  match = { class = "^(Rofi)$" },
})

-- make some layers transparent
hl.layer_rule({
  name = "fuzzel trans",
  blur = true,
  ignore_alpha = 0, -- stops corner overflow for some reason
  match = {
    namespace = "launcher",
  }
})

-- i hate microsoft
hl.window_rule({
  name = "fixMSProducts",
  no_focus = true,
  float = true,
  match = {
    class = "^(microsoft-edge)$",
    title = "^()$",
  }
})

hl.on("window.open", function (w)
  local f = io.open("/proc/" .. w.pid .. "/comm", "r")
  if not f then; return; end
  local name = f:read("*l")
  f:close()
  if name == "msedge" and w.class == "" and w.title == "" then
    hl.dispatch(hl.dsp.window.float({
      float = true,
      window = w.address,
    }))
  end
end)

-- i also hate zoom
hl.window_rule({
  name = "remove annotate toolbar",
  no_focus = true,
  float = true,
  match = {
    class = "zoom",
    title = "annotate_toolbar",
  },
})
