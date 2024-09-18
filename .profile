#!/bin/sh
# shellcheck disable=SC2155

# Profile file, runs on login. Environmental variables are set here.

# Add all directories in `~/.local/bin` to $PATH
export PATH="$PATH:$(find ~/.local/bin -type d | paste -sd ':' -)"

export EDITOR="nvim"
export TERMINAL="st"
export TERMINAL_PROG="st"
export BROWSER="brave"
