#!/usr/bin/env bash
# waybar custom module: github notification count via gh cli.

count=$(gh api notifications --jq 'length' 2>/dev/null)

if ! [[ "$count" =~ ^[0-9]+$ ]]; then
    printf '{"text":"","alt":"idle","tooltip":"GitHub notifications unavailable","class":"idle"}\n'
    exit 0
fi

if ((count > 0)); then
    printf '{"text":" %s","alt":"active","tooltip":"%s GitHub notification(s)","class":"active"}\n' "$count" "$count"
else
    printf '{"text":"","alt":"idle","tooltip":"No GitHub notifications","class":"idle"}\n'
fi
