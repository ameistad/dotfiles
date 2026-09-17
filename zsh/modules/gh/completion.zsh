# gh's completion into a cached dir on fpath; regenerated when the gh binary is newer.
# Written to a file rather than eval-ed because the output calls compdef (needs compinit).
if command -v gh >/dev/null 2>&1; then
  _gh_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
  [[ -d $_gh_dir ]] || mkdir -p "$_gh_dir"
  if [[ ! -s $_gh_dir/_gh || $_gh_dir/_gh -ot ${commands[gh]} ]]; then
    gh completion -s zsh > "$_gh_dir/_gh"
  fi
  fpath=("$_gh_dir" $fpath)
  unset _gh_dir
fi
