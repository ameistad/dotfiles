#!/usr/bin/env zsh

# Dedupe PATH/fpath no matter how often files are sourced or what a parent shell exported.
typeset -U path fpath

# Load local environment variables first
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# Always derive ZSH from this file's location. Don't trust an inherited value: an old
# shell, ~/.localrc or another framework may have exported ZSH pointing somewhere else.
# `readlink -f` needs GNU coreutils or macOS >= 12.3.
export ZSH="$(dirname "$(readlink -f "${(%):-%x}")")"

# all of our zsh files
typeset -U config_files
config_files=($ZSH/**/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  source $file
done

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done

unset config_files

# Function paths (fpath)
# zsh/functions holds functions and their _completions; a module dir may ship its own _foo files.
fpath=($ZSH/functions $ZSH/modules/*(N/) $fpath)

# Autocomplete
# Needs to load after adding the fpath(s). The dump is rebuilt at most once a day;
# after adding a new completion run: rm ~/.cache/zsh/zcompdump*
autoload -Uz compinit
() {
  # (#q...) inside [[ ]] only works with EXTENDED_GLOB, so set it locally.
  setopt localoptions extendedglob
  local dump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
  [[ -d ${dump:h} ]] || mkdir -p "${dump:h}"
  if [[ -n ${dump}(#qN.mh-24) ]]; then
    compinit -C -d "$dump"   # dump < 24h old: skip the fpath scan and compaudit
  else
    compinit -d "$dump"      # full rebuild
  fi
}

# Functions
autoload -Uz $ZSH/functions/*(N:t)

# Command-line highlighting (brew/apt: zsh-syntax-highlighting). Must be sourced last, after
# compinit and every widget (vi keys, fzf). Colors: modules/zsh-syntax-highlighting/styles.zsh.
for _zsh_hl in \
  {${HOMEBREW_PREFIX:-/opt/homebrew},/usr/local}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  [[ -r $_zsh_hl ]] && { source $_zsh_hl; break }
done
unset _zsh_hl
