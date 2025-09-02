autoload -Uz add-zsh-hook
autoload colors && colors
setopt PROMPT_SUBST

git=$(command -v git || echo "/usr/bin/git")

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

function git_info() {
  local branch=$($git symbolic-ref --short HEAD 2>/dev/null)
  [[ -z $branch ]] && return
  local git_status=$($git status --porcelain 2>/dev/null)
  local color=${colors[green]}
  [[ -n $git_status ]] && color=${colors[red]}
  echo "on \e[1m${color}${branch}${colors[reset]}"
}

function need_push() {
  if [[ -n $($git cherry -v @{upstream} 2>/dev/null) ]]; then
    echo " with %{\e[1m%}${colors[red]}unpushed${colors[reset]} "
  fi
}

function directory_name() {
  echo "\e[1m${colors[orange]}%2~${colors[reset]}"
}

function user_and_host() {
  echo "\e[1m${colors[dark-blue]}%n@%m${colors[reset]}"
}

function set_prompt() {
  export PROMPT=$'$(print -P "\n$(user_and_host) -> $(directory_name) $(git_info)$(need_push)\n› ")'
  export RPROMPT=""
}

function set_beam_cursor() {
  print -n '\e[5 q'
}

function title() {
  local title_text="${1:-zsh} ${2:-%m} ${3:-%~}"
  case $TERM in
    screen) print -Pn "\ek${title_text}\e\\" ;;
    xterm*|rxvt) print -Pn "\e]2;${title_text}\a" ;;
  esac
}

function set_all() {
  print -n "\e]1;${PWD##*/}\a"
  title "zsh" "%m" "%55<...<%~"
  set_prompt
  set_beam_cursor
}

add-zsh-hook precmd set_all
