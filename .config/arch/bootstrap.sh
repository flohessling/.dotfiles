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
omarchy-webapp-remove \
    "Basecamp" \
    "ChatGPT" \
    "Figma" \
    "Fizzy" \
    "GitHub" \
    "Google Contacts" \
    "Google Maps" \
    "Google Messages" \
    "Google Photos" \
    "HEY" \
    "X" \
    "YouTube" \
    "Zoom" ||
    true

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
omarchy-theme-install https://github.com/flohessling/omarchy-patina-theme.git

log "bootstrap complete."
