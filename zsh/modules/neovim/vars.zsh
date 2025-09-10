# Config directory
export XDG_CONFIG_HOME="$HOME/.config"

_EDITOR="$(command -v nvim)"
export EDITOR="$_EDITOR"
export VISUAL="$_EDITOR"
export SUDO_EDITOR="$_EDITOR"
unset _EDITOR
