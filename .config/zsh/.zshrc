# init shell with brew
if [[ $(uname) == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# oh-my-zsh config
export ZSH="$ZDOTDIR/ohmyzsh"
plugins=(git docker docker-compose aws fzf)
ZSH_CUSTOM="$HOME/.config/zsh/omz_custom"
ZSH_THEME="oxide"
source $ZSH/oh-my-zsh.sh

# use fzf
source <(fzf --zsh)

# use emacs keymap as default
bindkey -e

# init prompt
# autoload -U promptinit; promptinit
# prompt pure

# load plugins
autoload -U compinit && compinit
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# history options
HISTSIZE="10000"
SAVEHIST="10000"
HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt autocd

# keymap
WORDCHARS=""

zstyle ':completion:*' menu select

bindkey -M emacs '^[[H' beginning-of-line
bindkey -M emacs '^[[F' end-of-line
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M emacs '^[[3~' delete-char
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# xdg config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# configure paths
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# configure env
export EDITOR="nvim"
export DOCKER_BUILDKIT=1
export MANPAGER="nvim +Man!"
export AWS_PAGER=""
export HISTORY_SUBSTRING_SEARCH_PREFIXED="1"
export TERRAGRUNT_PROVIDER_CACHE="1"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export TF_PLUGIN_CACHE_DIR="$XDG_CACHE_HOME/terraform"
export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraform/config.tfrc"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brewfile/Brewfile"

export GOPATH="$HOME/code/go"
export GOPRIVATE="gitlab.shopware.com"

# dotfiles alias
alias dot="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# aliases
alias -- bcat='bat --theme "base16"'
alias -- cat='bat -pp --theme "base16"'
alias -- cdhm='cd ~/.config/home-manager'
alias -- ehm='v ~/.config/home-manager/home.nix'
alias -- gpo='git pull origin $(git_current_branch)'
alias -- hm=home-manager
alias -- lg=lazygit
alias -- notes='cd ~/notes && v home.md'
alias -- sso='aws sso login --sso-session root'
alias -- t='tmux new -As0'
alias -- tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale
alias -- v=nvim
alias -- vi=nvim
alias -- vim=nvim
alias -- wgdown-prod='sudo wg-quick down prod'
alias -- wgdown-staging='sudo wg-quick down staging'
alias -- wgup-prod='sudo wg-quick up prod'
alias -- wgup-staging='sudo wg-quick up staging'

# custom scripts
for f in $XDG_CONFIG_HOME/zsh/scripts.d/*; do source $f; done
for f in $XDG_CONFIG_HOME/zsh/scripts.private.d/*; do source $f; done
