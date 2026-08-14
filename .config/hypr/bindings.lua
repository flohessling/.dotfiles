-- Keep only your personal keybinding overrides here.
-- See current bindings and descriptions: omarchy menu keybindings --print
--
-- Quattro's stock bindings already cover most of the pre-Quattro bindings.conf
-- at identical combos with equivalent commands — Terminal, Tmux (same `-s Work`
-- session), Browser, Browser (private), File manager, File manager (cwd),
-- Editor, Docker, Signal, Obsidian, Passwords, YouTube and WhatsApp are all
-- stock now, so they are no longer redeclared here.
--
-- Only the four that genuinely differ from stock are overridden below. Each
-- unbinds the stock default first, as Quattro requires.

-- Music: Tidal rather than stock's Spotify.
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", 'omarchy-launch-or-focus tidal-hifi "uwsm-app -- tidal-hifi"')

-- Calendar + Email: work Outlook rather than stock's HEY.
hl.unbind("SUPER + SHIFT + C")
o.bind(
  "SUPER + SHIFT + C",
  "Calendar",
  'omarchy-launch-or-focus-webapp "Outlook Calendar" "https://outlook.cloud.microsoft/calendar"'
)

hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Email", 'omarchy-launch-or-focus-webapp "Outlook" "https://outlook.cloud.microsoft"')

-- Slack: takes the combo stock uses for Google Maps.
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Slack", 'omarchy-launch-or-focus-webapp "Slack" "https://shopware-ag.slack.com"')
