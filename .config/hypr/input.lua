-- Control your input devices.
-- Personal overrides only; everything else comes from Omarchy's defaults.
-- Ported from the pre-Quattro input.conf.

-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    -- Lower pointer sensitivity (default: 0).
    sensitivity = -0.3,

    touchpad = {
      -- Use natural (inverse) scrolling.
      natural_scroll = true,

      -- Quattro's default enables clickfinger; use bottom-corner right-click
      -- instead, which is what the pre-Quattro config did by leaving it off.
      clickfinger_behavior = false,
    },
  },
})

-- Per-app touchpad scroll speed.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
