#!/usr/bin/env bash

cdp() {
    local dirs=()
    [ -d ~/work ] && dirs+=(~/work)
    [ -d ~/personal ] && dirs+=(~/personal)
    if [ "$1" = "" ]; then
        selected=$(find "${dirs[@]}" -maxdepth 3 -mindepth 1 -type d | fzf)
    else
        selected=$(find "${dirs[@]}" -maxdepth 3 -mindepth 1 -type d | fzf -1 -q "$@")
    fi

    cd "$selected" || return
}
