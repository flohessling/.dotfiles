# .dotfiles

Personal dotfiles. Bare-git workflow, single `main` branch with platform conditionals.

- **macOS**: `brew bundle` against the included Brewfile.
- **Linux (Omarchy / Arch)**: `first-run.sh` then `bootstrap.sh`.

Secrets (`~/.ssh/`, `~/.aws/`, etc.) are encrypted with [git-crypt]. The unlock key lives in 1Password as a Document named `dotfiles`.

[git-crypt]: https://github.com/AGWA/git-crypt

## Setup

### 1. 1Password (manual, one-time)

Sign into the 1Password desktop app, then **Settings → Developer**:

- [x] Integrate with 1Password CLI
- [x] Use the SSH agent

Verify:

```
op whoami
```

### 2. Clone via HTTPS

`~/.ssh/config` is itself encrypted, so SSH won't authenticate at clone time. Clone over HTTPS — `first-run.sh` swaps the remote to SSH after decryption.

```
git clone --bare https://github.com/flohessling/.dotfiles.git $HOME/.dotfiles

alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

dot config --local status.showUntrackedFiles no
dot checkout -f main
```

### 3a. Bootstrap on Linux (Omarchy)

```
# unlock secrets, install git-crypt, swap remote to ssh, clean nvim residue
bash $HOME/.config/arch/first-run.sh

# clone vim.pack plugins (~30 repos, takes a minute)
nvim +qa

# install pacman + aur packages, service toggles, etc.
bash $HOME/.config/arch/bootstrap.sh

exec zsh
```

### 3b. Bootstrap on macOS

```
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# install git-crypt and unlock secrets
brew install git-crypt
op document get dotfiles --force | dot crypt unlock -
dot checkout HEAD -- .
dot remote set-url origin git@github.com:flohessling/.dotfiles.git

# point platform-conditional git config at the darwin variant
ln -sf config-darwin $HOME/.config/git/config-platform

# install everything from the brewfile
brew bundle --file $HOME/.config/brewfile/Brewfile

exec zsh
```

### 4. Verify

```
file ~/.ssh/config        # should be 'ASCII text' (decrypted)
ssh-add -L                # should list 1Password keys
ssh -T git@github.com     # should auth via 1Password SSH agent
dot status                # should be clean
```
