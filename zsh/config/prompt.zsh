autoload -Uz add-zsh-hook
autoload colors && colors
setopt PROMPT_SUBST

_prompt_git=$(command -v git || echo "/usr/bin/git")

declare -A colors=(
  [reset]="%{\e[0m%}"
  [green]="%{\e[38;2;146;156;105m%}"   # etterglod soft green (#929c69)
  [red]="%{\e[38;2;175;91;86m%}"       # etterglod soft red (#af5b56)
  [yellow]="%{\e[38;2;255;238;128m%}"  # etterglod yellow (#ffee80)
  [cyan]="%{\e[38;2;75;166;203m%}"     # etterglod type (#4ba6cb)
  [dark-blue]="%{\e[38;2;31;82;141m%}" # etterglod dark blue (#1f528d)
  [orange]="%{\e[38;2;235;181;121m%}"  # etterglod orange (#ebb579)
  [fg]="%{\e[38;2;197;200;198m%}"      # etterglod fg (#c5c8c6)
)

# One `git status` call yields branch, dirty state and ahead count (one fork per prompt).
# Untracked files count as dirty. If a huge repo ever lags, add `-uno` to the status
# call; untracked files then stop turning the branch red.
function git_prompt_info() {
  local line branch color dirty=0 ahead=0
  local -a lines
  lines=(${(f)"$($_prompt_git status --porcelain=v2 --branch --ignore-submodules 2>/dev/null)"})
  (( ${#lines} )) || return          # not a repo
  for line in $lines; do
    case $line in
      '# branch.head (detached)') return ;;
      '# branch.head '*) branch=${line#'# branch.head '} ;;
      '# branch.ab '*)   ahead=${${line#'# branch.ab +'}%% *} ;;   # absent when no upstream
      '#'*) ;;
      *) dirty=1 ;;                                          # 1/2/u/? entries
    esac
  done
  [[ -z $branch ]] && return
  color=${colors[green]}
  (( dirty )) && color=${colors[red]}
  local out="on %{\e[1m%}${color}${branch}${colors[reset]}"
  (( ahead > 0 )) && out+=" with %{\e[1m%}${colors[red]}unpushed${colors[reset]} "
  echo "$out"
}

function directory_name() {
  echo "%{\e[1m%}${colors[orange]}%2~${colors[reset]}"
}

function user_and_host() {
  echo "%{\e[1m%}${colors[dark-blue]}%n@%m${colors[reset]}"
}

# Set once: PROMPT_SUBST re-runs the $(...) parts on every prompt, so %{...%} still marks
# nonprinting codes and the git info stays current.
PROMPT=$'\n$(user_and_host) -> $(directory_name) $(git_prompt_info)\n› '
RPROMPT=""

function title() {
  local title_text="${1:-zsh} ${2:-%m} ${3:-%~}"
  case $TERM in
    screen*|tmux*) print -Pn "\ek${title_text}\e\\" ;;
    xterm*|rxvt) print -Pn "\e]2;${title_text}\a" ;;
  esac
}

function set_all() {
  print -n "\e]1;${PWD##*/}\a"
  title "zsh" "%m" "%55<...<%~"
}

add-zsh-hook precmd set_all
