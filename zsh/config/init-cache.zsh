# Cache the output of tool init commands (`fzf --zsh`, `zoxide init zsh`) instead of
# forking them on every shell. Loads before modules/* (config/* sorts first).
#
# usage: _init_cache <name> <command...> && source $REPLY
# Sets REPLY to the cache file; the caller sources it at top level, because sourcing inside
# a function would turn the script's typesets into locals. The file is regenerated when the
# resolved binary changes (Homebrew upgrades land in a new Cellar path) or is newer than it.
# Returns 1 when the tool is missing or the command fails (e.g. an fzf without --zsh).
_init_cache() {
  local name=$1 bin=${commands[$2]:A} stamp
  shift
  REPLY="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init-$name.zsh"
  [[ -n $bin ]] || return 1
  [[ -r $REPLY ]] && read -r stamp < "$REPLY"
  if [[ $stamp != "# $bin" || $REPLY -ot $bin ]]; then
    [[ -d ${REPLY:h} ]] || mkdir -p "${REPLY:h}"
    if ! { print -r -- "# $bin" && "$@" } >| "$REPLY" 2>/dev/null; then
      command rm -f -- "$REPLY"
      return 1
    fi
  fi
}
