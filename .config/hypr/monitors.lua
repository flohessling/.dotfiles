-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all
--
-- Monitor layout is managed by kanshi (~/.config/kanshi/config), applied via
-- the kanshi.service systemd user unit. Do NOT use hyprmon — it re-adds
-- ambiguous rules that fight kanshi.
--
-- The fallback below only applies briefly before kanshi runs, or for any
-- monitor not covered by a kanshi profile.

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.5 })

-- Quattro's stock monitors.lua sets hl.env("GDK_SCALE", "2"), which renders GTK
-- apps at 2x on this mixed-scale setup (eDP-1 1.5, DP-4 1.0, DP-6 1.5). kanshi
-- can override monitor scale at runtime but cannot override a Hyprland env var,
-- so it is deliberately left unset here, matching the pre-Quattro config.
-- Nothing else in Omarchy reads GDK_SCALE; apparent text size is a separate
-- knob: `omarchy display text size <px>`.

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })
