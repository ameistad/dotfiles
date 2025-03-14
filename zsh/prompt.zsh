autoload -Uz add-zsh-hook
autoload colors && colors
setopt PROMPT_SUBST

git=$(command -v git || echo "/usr/bin/git")

declare -A colors=(
  [reset]="%{\e[0m%}"
  [green]="%{\e[38;2;146;156;105m%}"   # Olive green (#929c69)
  [red]="%{\e[38;2;175;91;86m%}"       # Soft red (#af5b56)
  [yellow]="%{\e[38;2;228;194;131m%}"  # Warm yellow (#e4c283)
  [cyan]="%{\e[38;2;0;255;255m%}"      # Cyan
  [dark-blue]="%{\e[38;2;31;82;141m%}" # Dark blue (#1f528d)
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
  echo "\e[1m${colors[yellow]}%2~${colors[reset]}"
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
