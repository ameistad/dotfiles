# Case-insensitive both ways, then allow partial-word matches on . _ -
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'

# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# cd .. <tab> to cd ../
zstyle ':completion:*' special-dirs true

# Persistent rehash. Find newly installed executables in PATH.
zstyle ':completion:*' rehash true

# Select menu if number of items > 2.
zstyle ':completion:*' menu select=2

# Cache slow completers (brew, docker, gh, ...)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Colors and grouping (LS_COLORS is set in config.zsh, which loads earlier)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages'     format '%F{cyan}-- %d --%f'
zstyle ':completion:*:warnings'     format '%F{red}-- no matches --%f'
