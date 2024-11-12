# .dotfiles

This repository contains my `.dotfiles` configuration to setup or restore my mac environment.

It is making use of `git` and `homebrew`. Not much else should be needed.

## Setup

To start with this configuration we need to clone this repository first using `git clone --bare`.

### Install oh-my-zsh
```
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Cloning the repository

Using the `--bare` option when cloning this repository makes it possible to have all files from this repository tracked in `$HOME` and not needing to symlink anything.

```
git clone --bare git@github.com:flohessling/.dotfiles.git $HOME/.dotfiles

alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot checkout
dot config --local status.showUntrackedFiles no
```

The config option hides all untracked files in `$HOME` and makes `git status` actually usable.

### Install homebrew and packages

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" # for linux

brew bundle --file .config/brewfile/Brewfile
```

### Decrypt secrets

The secrets are en- / decrypted using the unlock key (which is required for this action to work, obviously)

```
# 1password
op document get dotfiles --force | dot crypt unlock -

# key file
dot crypt unlock dotfiles.key
```

### Restart shell (zsh)

After setting everything up following the steps above the shell has to be restarted and should be ready afterwards.
