-- Extra autostart processes.
-- Ported from the pre-Quattro autostart.conf.

-- Cursor theme. The theme lives at ~/.local/share/icons/WhiteSur-cursors, so the
-- lookup name is the directory name (the old config used "WhiteSur cursors"
-- with a space, which does not match the directory). Omarchy's envs.lua already
-- sets XCURSOR_SIZE/HYPRCURSOR_SIZE to 24, so only the theme is set here.
hl.env("XCURSOR_THEME", "WhiteSur-cursors")

-- The env var only reaches processes started after it is set, so also apply it
-- to the running session on login.
o.exec_on_start('hyprctl setcursor "WhiteSur-cursors" 24')
