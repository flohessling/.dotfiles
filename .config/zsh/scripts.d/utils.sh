#!/usr/bin/env bash

cdp() {
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(find ~/code -maxdepth 3 -mindepth 1 -type d | fzf)
    fi

    cd "$selected" || return
}
