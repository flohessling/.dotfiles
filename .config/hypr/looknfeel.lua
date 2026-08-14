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

    -- Window drop shadows. Omarchy 3.x enabled these in its stock decoration
    -- block with these exact values, and the old looknfeel.conf inherited them
    -- by not overriding the block. Quattro deliberately ships
    -- `shadow = { enabled = false }`, so they have to be restated to come back.
    shadow = {
      enabled = true,
      range = 2,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },

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

      -- Blur the special workspace (SUPER+S scratchpad). Omarchy 3.x set this
      -- in its stock blur block and Hyprland .conf blocks merged, so the old
      -- override inherited it. Quattro's stock block sets only `enabled`, and
      -- Hyprland's own default is false — without this the scratchpad only
      -- darkens instead of blurring.
      special = true,
    },
  },
})

-- Frost the Omarchy shell's layer-shell surfaces.
--
-- Enabling blur globally above does not reach layer-shell surfaces; each
-- namespace needs its own rule. Quattro ships rules for these namespaces but
-- only sets no_anim, never blur. The matching translucency lives in patina
-- (shell.bar.toml / shell.menu.toml / shell.launcher.toml /
-- shell.notifications.toml) — alpha without this blur is just see-through.
--
-- omarchy-background is deliberately excluded: it is the wallpaper layer.

-- ignore_alpha matters here: the omarchy-notifications layer is full-monitor
-- sized (one per display), not notification-sized, so blurring it unconditionally
-- frosts the entire screen whenever a notification appears. 0.3 sits below the
-- card's 0.663 but above the transparent surround, so only the card blurs.
hl.layer_rule({
  match = { namespace = "^(omarchy-bar|omarchy-notifications)$" },
  blur = true,
  ignore_alpha = 0.3,
})

-- The menu family draws a full-screen layer: a 0.5 scrim plus a 0.8 card.
-- ignore_alpha = 0.6 keeps the scrim crisp and blurs only the card, matching
-- the pre-Quattro look where menus were small popups over an undimmed screen.
-- Clipboard and emojis inherit the [menu] tokens, so they are included here.
hl.layer_rule({
  match = { namespace = "^(omarchy-menu|omarchy-clipboard|omarchy-emojis)$" },
  blur = true,
  ignore_alpha = 0.6,
})
