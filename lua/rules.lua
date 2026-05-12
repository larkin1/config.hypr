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
