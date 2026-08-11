# .dotfiles

Personal dotfiles for Omarchy / Arch Linux. Bare-git workflow on a single `main` branch.

Bootstrap: `first-run.sh` then `bootstrap.sh` (see below).

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

### 3. Bootstrap

```
# unlock secrets, install git-crypt, swap remote to ssh, clean nvim residue
bash $HOME/.config/arch/first-run.sh

# clone vim.pack plugins (~30 repos, takes a minute)
nvim +qa

# install pacman + aur packages, service toggles, etc.
bash $HOME/.config/arch/bootstrap.sh

exec zsh
```

### 4. Verify

```
file ~/.ssh/config        # should be 'ASCII text' (decrypted)
ssh-add -L                # should list 1Password keys
ssh -T git@github.com     # should auth via 1Password SSH agent
dot status                # should be clean
```
