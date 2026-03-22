#!/usr/bin/env bash
set -euo pipefail

# Check tmuxinator is installed
if ! command -v tmuxinator &>/dev/null; then
    echo "tmuxinator is not installed. Please install it first."
    exit 1
fi

# Check we are inside a git repository
if ! git rev-parse --show-toplevel &>/dev/null; then
    echo "Not inside a git repository."
    exit 1
fi

# Determine session/project name
SESSION_NAME=$(basename "$PWD")

# Determine config directory according to XDG spec
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="$CONFIG_HOME/tmuxinator"
mkdir -p "$CONFIG_DIR"

CONFIG_FILE="$CONFIG_DIR/$SESSION_NAME.yml"

# Prevent overwriting existing config accidentally
if [[ -f "$CONFIG_FILE" ]]; then
    echo "Config $CONFIG_FILE already exists. Use --force to overwrite."
    exit 1
fi

# Generate tmuxinator YAML with default template
cat > "$CONFIG_FILE" <<EOF
name: $SESSION_NAME
root: $PWD
windows:
  - Editor: nvim .
  - Terminal:
EOF

echo "Opening project configuration for editing in nvim..."

# Open the generated file in Neovim for immediate editing
nvim "$CONFIG_FILE"
echo "Tmuxinator project '$SESSION_NAME' created at $CONFIG_FILE"
