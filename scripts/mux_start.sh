#!/usr/bin/env bash
set -euo pipefail

projects=$(tmuxinator list -n | tail -n +2 | tr ' ' '\n' | sed '/^$/d')

if [[ -z "$projects" ]]; then
  echo "No tmuxinator projects found"
  exit 1
fi

selected=$(echo "$projects" | fzf --reverse --prompt='start> ')

if [[ -n "$selected" ]]; then
  tmuxinator start "$selected"
fi
