# Config directory
export XDG_CONFIG_HOME="$HOME/.config"

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="$(command -v nvim)"
  export VISUAL="$EDITOR"
  export SUDO_EDITOR="$EDITOR"
fi
