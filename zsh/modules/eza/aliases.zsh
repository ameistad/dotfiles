# ls family: eza when present; else colored GNU ls on Linux, plain BSD ls on macOS (CLICOLOR is set).
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --group-directories-first --git'
  alias la='eza -la --group-directories-first --git'
  alias lt='eza --tree --level=2 --group-directories-first'
else
  [[ $OSTYPE == linux* ]] && alias ls='ls --color=auto --group-directories-first'
  alias ll='ls -l'
  alias la='ls -la'
  command -v tree >/dev/null 2>&1 && alias lt='tree -L 2'
fi
