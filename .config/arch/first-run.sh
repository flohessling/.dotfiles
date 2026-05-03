#!/usr/bin/env bash
#
# one-shot first-run setup on a fresh omarchy machine
#
# preconditions:
#   - bare dotfiles clone exists at ~/.dotfiles (HTTPS remote)
#   - omarchy/main branch already checked out into $HOME
#   - 1Password sign in via gui, with cli integration and ssh agent enabled

set -euo pipefail

# ── guards
[[ "$(uname -s)" == Linux ]] || {
    echo "linux-only"
    exit 1
}

[[ -d "$HOME/.dotfiles" ]] || {
    echo "bare repo not found at ~/.dotfiles. clone first." >&2
    exit 1
}

command -v op >/dev/null || {
    echo "1password-cli (op) not found." >&2
    exit 1
}

if ! op whoami >/dev/null 2>&1; then
    cat >&2 <<'EOF'
1Password CLI not signed in...

open 1Password → Settings → Developer:
  [x] Integrate with 1Password CLI
  [x] Use the SSH agent

then re-run this script.
EOF
    exit 1
fi

# ── helpers
dot() { git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"; }
log() { printf '\033[1;34m>\033[0m %s\n' "$*"; }

# ── install git-crypt
log "installing git-crypt"
sudo pacman -S --needed --noconfirm git-crypt

# ── unlock with key from 1Password
if [[ -f "$HOME/.dotfiles/git-crypt/keys/default/0" ]]; then
    log "git-crypt already unlocked, skipping"
else
    log "fetching key from 1Password and unlocking"
    op document get dotfiles --force | dot crypt unlock -
fi

# ── re-checkout so the smudge filter actually runs
log "re-applying smudge filter to encrypted files"
cd "$HOME"
dot checkout HEAD -- .

# ── nvim config: remove omarchy-nvim residue not tracked by dotfiles
# omarchy-nvim drops LazyVim scaffolding (lua/config/, lua/plugins/*.lua,
# lazy-lock.json, lazyvim.json) that conflicts with our vim.pack setup.
# `dot clean -fd` removes anything under ~/.config/nvim not tracked by the
# dotfiles repo — surgical, future-proof against new files omarchy-nvim
# might drop. Bootstrap.sh later removes the package itself.
log "cleaning omarchy-nvim residue from ~/.config/nvim"
dot clean -fd -- .config/nvim

# ── swap origin to ssh (now that ~/.ssh is decrypted)
log "switching origin to SSH"
dot remote set-url origin git@github.com:flohessling/.dotfiles.git

# ── platform-conditional git config (gpg/op-ssh-sign paths)
log "linking platform-specific git config"
ln -sf "config-$(uname -s | tr '[:upper:]' '[:lower:]')" \
    "$HOME/.config/git/config-platform"

# ── nvim runtime state: wipe everything plugin-manager-related
# - vim.pack opt: clones via https URLs that ~/.gitconfig rewrites to ssh,
#   so any clone attempted before ssh was set up half-finishes in subtle
#   ways (empty work-tree, missing objects, partial branch checkouts).
#   Detecting every broken shape is fragile — just nuke and re-clone.
# - lazy.nvim: omarchy ships a LazyVim default; we use vim.pack instead.
# - site/parser + site/queries: nvim-treesitter creates parser binaries and
#   query symlinks here. After plugin-manager swap (lazy → vim.pack), the
#   query symlinks point at the old plugin path → highlighter attaches but
#   produces zero captures → file looks unhighlighted while treesitter is
#   technically running. Nuking forces install() to rebuild fresh.
log "wiping nvim runtime state (vim.pack opt, lazy residue, parser/query symlinks)"
rm -rf "$HOME/.local/share/nvim/site/pack/core/opt" \
       "$HOME/.local/share/nvim/site/parser" \
       "$HOME/.local/share/nvim/site/queries" \
       "$HOME/.local/share/nvim/lazy" \
       "$HOME/.local/share/nvim/lazyvim"

# ── project dirs
# Rename ~/Work (omarchy default) to ~/work for consistency.
# Ensure ~/personal exists too — git config has `includeIf gitdir:~/personal/`
# pointing at config-personal, so the directory needs to be present for the
# include to actually fire on personal projects.
if [[ -d "$HOME/Work" && ! -e "$HOME/work" ]]; then
    log "renaming ~/Work to ~/work"
    mv "$HOME/Work" "$HOME/work"
fi
mkdir -p "$HOME/personal"

# ── done
log "first-run complete."
cat <<'EOF'

next steps:
  file ~/.ssh/config              # should report 'ASCII text'
  ssh-add -L                      # should list 1Password keys
  nvim                            # first launch will clone vim.pack plugins
  bash ~/.config/arch/bootstrap.sh
  exec zsh
EOF
