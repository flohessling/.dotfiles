#!/usr/bin/env bash
#
# idempotent post-first-run setup on omarchy.
# safe to re-run after every omarchy-update.

set -euo pipefail

# ── guards
[[ "$(uname -s)" == Linux ]] || {
    echo "linux-only"
    exit 1
}

# ── helpers
log() { printf '\033[1;34m>\033[0m %s\n' "$*"; }
strip_comments() { sed -E 's/[[:space:]]*#.*$//' "$1" | grep -vE '^\s*$'; }

PKG_DIR="$HOME/.config/arch/pkgs"

# ── remove unwanted packages first (omarchy defaults / replaced ones)
# Done before installs so conflicting pairs (e.g. tldr ↔ tealdeer) don't
# cause "unresolvable package conflicts" during pacman -S.
# Per-package check via exact-name match: `pacman -Qq <name>` matches by
# `provides=` too (so it falsely succeeds for e.g. tldr when only tealdeer
# is installed), but `pacman -Rns` requires exact name and would error
# "target not found". Listing all packages and grep-x avoids that.
log "removing unwanted packages"
installed_packages=$(pacman -Qq)
while IFS= read -r pkg; do
    [[ -z $pkg ]] && continue
    if grep -qx "$pkg" <<<"$installed_packages"; then
        sudo pacman -Rns --noconfirm "$pkg"
    fi
done < <(strip_comments "$PKG_DIR/remove-pacman.txt")

# ── install pacman packages
# xargs -r skips invocation if stdin is empty (file all-comments / missing).
log "installing pacman packages"
strip_comments "$PKG_DIR/pacman.txt" | xargs -r sudo pacman -S --needed --noconfirm

# ── install AUR packages via yay
log "installing AUR packages"
strip_comments "$PKG_DIR/aur.txt" | xargs -r yay -S --needed --noconfirm

# ── install mise-managed tools
# Declared in ~/.config/mise/config.toml; `mise install` with no args installs
# everything in the config. Omarchy puts ~/.local/share/mise/shims on PATH
# session-wide (uwsm env.d), and shims are only generated on install — so
# without this step a declared tool is simply not on PATH.
# MISE_MINIMUM_RELEASE_AGE=0 matches what omarchy-update-mise does: mise
# otherwise withholds releases younger than its cooldown.
log "installing mise tools"
MISE_MINIMUM_RELEASE_AGE=0 mise install

# ── default terminal: ghostty
# omarchy-install-terminal installs the package, copies the .desktop file,
# and rewrites ~/.config/xdg-terminals.list so xdg-terminal-exec picks it.
log "setting ghostty as default terminal"
omarchy-install-terminal ghostty

# ── default browser: zen
# xdg-settings is what omarchy-launch-browser reads. Idempotent: skip if
# already set; gracefully skip if zen.desktop isn't present yet.
if [[ -f /usr/share/applications/zen.desktop || -f $HOME/.local/share/applications/zen.desktop ]]; then
    current_browser=$(xdg-settings get default-web-browser 2>/dev/null || echo "")
    if [[ $current_browser != "zen.desktop" ]]; then
        log "setting zen as default browser"
        xdg-settings set default-web-browser zen.desktop
    else
        log "zen already default browser, skipping"
    fi
else
    log "zen.desktop not found, skipping default-browser step"
fi

# ── oh-my-zsh
# .zshrc sources $ZSH/oh-my-zsh.sh; install if missing so the first zsh
# launch after chsh doesn't error out.
if [[ ! -d "$HOME/.config/zsh/ohmyzsh" ]]; then
    log "installing oh-my-zsh"
    ZSH="$HOME/.config/zsh/ohmyzsh" RUNZSH=no CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ── default shell: zsh
target_shell=$(command -v zsh)
current_shell=$(getent passwd "$USER" | cut -d: -f7)
if [[ "$current_shell" != "$target_shell" ]]; then
    log "setting zsh as default login shell"
    sudo chsh -s "$target_shell" "$USER"
else
    log "zsh already default, skipping"
fi

# ── webapps: remove omarchy defaults i don't use
# `|| true` so missing ones don't abort under set -e.
log "removing unwanted default webapps"
for app in \
    "Basecamp" "ChatGPT" "Figma" "GitHub" "Google Contacts" "Google Maps" "Google Messages" \
    "Google Photos" "HEY" "X" "Zoom"; do
    OMARCHY_REMOVE_NOTIFY=false omarchy-webapp-remove "$app" || true
done

# ── webapps: install the ones tied to my hypr keybinds
# omarchy-webapp-install <Name> <URL> <Icon>
# Empty icon arg falls back to https://www.google.com/s2/favicons?...
log "installing preferred webapps"
ICON_BASE="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png"
omarchy-webapp-install "Slack" "https://shopware-ag.slack.com" "$ICON_BASE/slack.png"
omarchy-webapp-install "Outlook" "https://outlook.cloud.microsoft" "$ICON_BASE/microsoft-outlook.png"
omarchy-webapp-install "Outlook Calendar" "https://outlook.cloud.microsoft/calendar" "$ICON_BASE/microsoft-outlook.png"
omarchy-webapp-install "Teams" "https://teams.cloud.microsoft" "$ICON_BASE/microsoft-teams.png"

# ── omarchy theme
log "installing and activating patina theme for omarchy"
omarchy-theme-install https://github.com/flohessling/omarchy-patina-theme.git
omarchy-theme-set patina

# ── omarchy shell plugins
# Installed without --enable on purpose: the tracked ~/.config/omarchy/shell.json
# already places the widget in bar.layout, so --enable risks a duplicate entry
# depending on whether the dotfiles checkout happens before or after this runs.
# `--yes` enforces that: it skips both the trust prompt and the "Enable now?"
# prompt, leaving the plugin installed-but-not-enabled every time.
# Note the https URL is rewritten to ssh by ~/.config/git/config, so this needs
# the 1Password SSH agent to be up — first-run.sh already gates on that.
#
# `omarchy plugin add` is NOT idempotent: it exits 1 with "plugin id is already
# installed" when the directory exists, which under `set -e` would abort the
# whole bootstrap on re-run. Hence the guard — the plugin id, not the repo name,
# is the directory name.
log "installing omarchy shell plugins"
install_plugin() {
    local url=$1 id=$2
    if [[ -e "$HOME/.config/omarchy/plugins/$id" ]]; then
        log "plugin $id already installed, skipping"
        return 0
    fi
    omarchy plugin add "$url" --yes
}

install_plugin https://github.com/robzolkos/omarchy-github.git robzolkos.github
install_plugin https://github.com/flohessling/omarchy-stats.git flohessling.stats

# ── wire gtk apps to active omarchy theme
# Omarchy 4 (Quattro) moved theme state from ~/.config/omarchy/current to
# ~/.local/state/omarchy/current. Relative to ~/.config/gtk-*, that is two
# levels up to $HOME and then into .local/state.
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
ln -sfn ../../.local/state/omarchy/current/theme/gtk.css ~/.config/gtk-3.0/gtk.css
ln -sfn ../../.local/state/omarchy/current/theme/gtk.css ~/.config/gtk-4.0/gtk.css

log "bootstrap complete."
