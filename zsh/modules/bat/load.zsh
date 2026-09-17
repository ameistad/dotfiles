# bat is `batcat` on Debian/Ubuntu.
_bat=$(whence -p bat || whence -p batcat)   # whence -p: binary path, never an alias
if [[ -n $_bat ]]; then
  [[ ${_bat:t} == batcat ]] && alias bat=batcat
  export BAT_THEME=ansi                            # etterglod isn't a bat theme; ansi = terminal palette
  alias cat="$_bat --paging=never --style=plain"   # plain cat + colors; `command cat` for the real one
  if command -v col >/dev/null 2>&1; then          # col: BSD on macOS, bsdextrautils on Debian
    export MANPAGER="sh -c 'col -bx | $_bat -l man -p'"
    export MANROFFOPT='-c'                         # stop man-db/groff emitting escapes bat can't parse
  fi
fi
unset _bat
