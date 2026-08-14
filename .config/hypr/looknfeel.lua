-- Change the default Omarchy look'n'feel.
-- Personal overrides, loaded after Omarchy's defaults. Ported from the
-- pre-Quattro looknfeel.conf, which is now inert.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    border_size = 1,
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
  decoration = {
    -- Use round window corners. Quattro's default is 0.
    rounding = 6,

    -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
    dim_inactive = true,
    dim_strength = 0.15,

    -- Quattro ships blur disabled; 3.x shipped it on at size 2 / passes 2.
    -- Without blur, the stock `opacity 0.985 0.96` window rule plus the
    -- terminals' own alpha (foot 0.9, ghostty 0.96) reads as plainly
    -- see-through rather than frosted.
    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      new_optimizations = true,
      popups = true,
      noise = 0.05,
      contrast = 1.1,
      brightness = 1,
      vibrancy = 0.17,
    },
  },
})
