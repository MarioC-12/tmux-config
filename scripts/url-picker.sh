#!/usr/bin/env bash
tmux capture-pane -e -J -p -S -500 > /tmp/tmux-urls-color
tmux capture-pane -J -p -S -500 > /tmp/tmux-urls-buf

awk '{
  line=$0
  while (match(line, /https?:\/\/[^ )>"]+/)) {
    url = substr(line, RSTART, RLENGTH)
    print NR "|" url
    line = substr(line, RSTART + RLENGTH)
  }
}' /tmp/tmux-urls-buf | tac | \
fzf --reverse --with-nth=2 --delimiter='\|' \
  --preview 'line={1}; start=$((line<15?1:line-15)); sed -n "${start},$((line+15))p" /tmp/tmux-urls-color | awk -v target="$((line-start+1))" -v plain="$(sed -n "${line}p" /tmp/tmux-urls-buf)" "NR==target {gsub(/https?:\/\/[^ )>\"]+/, \"\033[1;4m&\033[22;24m\", plain); printf \"\033[48;2;45;63;118m%s\033[0m\n\", plain; next} {print}"' \
  --preview-window=up:31:wrap | \
cut -d'|' -f2 | xargs -r xdg-open
