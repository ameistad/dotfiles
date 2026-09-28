if command -v zoxide >/dev/null 2>&1; then
  # Cached (config/init-cache.zsh). After changing _ZO_* settings: rm ~/.cache/zsh/init-zoxide.zsh
  _init_cache zoxide zoxide init zsh && source $REPLY
fi
