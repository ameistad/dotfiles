# Matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# cd .. <tab> to cd ../
zstyle ':completion:*' special-dirs true

# Persistent rehash. Find newly installed executables in PATH.
# https://github.com/robbyrussell/oh-my-zsh/issues/3440
zstyle ':completion:*' rehash true

# Select menu if number of items > 2.
zstyle ':completion:*' menu select=2