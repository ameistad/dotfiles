autoload colors && colors
setopt PROMPT_SUBST

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

# git stuff
git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[red]%}unpushed%{$reset_color%} "
  fi
}

# Virtualenv
# displays current active virtual environment in prompt
virtual_env() {
  if [ -n "$VIRTUAL_ENV" ]; then
    if [ -f "$VIRTUAL_ENV/__name__" ]; then
        local name=`cat $VIRTUAL_ENV/__name__`
    elif [ `basename $VIRTUAL_ENV` = "__" ]; then
      local name=$(basename $(dirname $VIRTUAL_ENV))
    else
      local name=$(basename $VIRTUAL_ENV)
    fi
      echo "ve:%{$fg_bold[yellow]%}$name%{$reset_color%} "
  fi
}

# Python anaconda
# Determines prompt modifier if and when a conda environment is active
anaconda() {
  if [[ -n $CONDA_PREFIX ]]; then
      if [[ $(basename $CONDA_PREFIX) == "miniconda3" ]]; then
        # Without this, it would display conda version
        echo "ac:%{$fg_bold[yellow]%}base%{$reset_color%} "
      else
        # For all environments that aren't (base)
        echo "ac:%{$fg_bold[yellow]%}$(basename $CONDA_PREFIX)%{$reset_color%} "
      fi
  # When no conda environment is active, don't show anything
  else
    CONDA_ENV=""
  fi
}

# Docker machine
# displays current docker-machine in prompt
docker_machine() {
  if [ -n "$DOCKER_MACHINE_NAME" ]; then
    echo "dm:%{$fg_bold[green]%}"$DOCKER_MACHINE_NAME"%{$reset_color%} "
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%3/%\/%{$reset_color%}"
}

export PROMPT=$'\n$(virtual_env)$(anaconda)$(docker_machine)$(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

# Sets the tab title to current directory
precmd() {
  echo -ne "\e]1;${PWD##*/}\a"

  title "zsh" "%m" "%55<...<%~"
  set_prompt
}

# Sets the window title nicely no matter where you are
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}
