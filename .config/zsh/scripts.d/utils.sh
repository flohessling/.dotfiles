#!/usr/bin/env bash

cdp() {
    if [ "$1" = "" ]; then
        selected=$(find ~/code -maxdepth 3 -mindepth 1 -type d | fzf)
    else
        selected=$(find ~/code -maxdepth 3 -mindepth 1 -type d | fzf -1 -q "$@")
    fi

    cd "$selected" || return
}
