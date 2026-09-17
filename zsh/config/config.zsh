# ---------- Shell behaviour ----------
setopt AUTO_CD               # `dir` == `cd dir`
setopt AUTO_PUSHD            # every cd pushes; `cd -<Tab>` / popd to go back
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB         # ^ ~ # in patterns (git gets `noglob`, see modules/git)
setopt INTERACTIVE_COMMENTS  # allow # comments at the prompt (pasting snippets)
setopt NO_BEEP
setopt NO_FLOW_CONTROL       # frees ^S/^Q
# CORRECT is deliberately off: it fights every CLI with sub-commands (git, docker, gh).
# NO_CASE_GLOB is deliberately off: Linux filesystems are case-sensitive.

# ---------- History ----------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY        # timestamp + duration per entry
setopt SHARE_HISTORY           # write immediately, read from other sessions
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE       # leading space = don't record
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY             # `!!` expands into the line first
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

# ---------- Colors ----------
export CLICOLOR=true
export LSCOLORS="ExGxHxdxbxegedabagacad"           # BSD ls (macOS)
# GNU-style LS_COLORS for completion list-colors, eza, fd, GNU ls.
if [[ -z $LS_COLORS ]]; then
  # Linux coreutils. dircolors emits an empty value when TERM is unknown (e.g. dumb).
  command -v dircolors >/dev/null 2>&1 && eval "$(dircolors -b)"
  # Fallback (macOS, or unknown TERM): same palette as LSCOLORS above.
  [[ -n $LS_COLORS ]] || export LS_COLORS='di=1;34:ln=1;36:so=1;37:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
fi
