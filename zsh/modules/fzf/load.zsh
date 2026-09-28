# fzf: Ctrl-R history, Ctrl-T files/dirs, Alt-C cd.
# Runs after config/keybindings.zsh (config/* sorts before modules/*), so `bindkey -v`
# is done. fzf >= 0.48 binds emacs/vicmd/viins itself; the older Debian/Ubuntu scripts
# bind `main`, which is viins by now. Either way ^R replaces vi's redisplay/redo.
command -v fzf >/dev/null 2>&1 || return 0

if _init_cache fzf fzf --zsh; then                                  # fzf >= 0.48, cached
  source $REPLY
elif [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then    # Debian/Ubuntu apt fzf
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ -r /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
fi

# etterglod palette (config/prompt.zsh, ghostty/config). bg/gutter -1 = terminal background.
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --info=inline \
--color=bg:-1,gutter:-1,bg+:#2c2c2c,fg:#c5c8c6,fg+:#e9e9e9,hl:#4ba6cb,hl+:#4ba6cb \
--color=prompt:#929c69,pointer:#ffee80,marker:#ffee80,info:#ebb579,spinner:#ebb579,header:#676b71,border:#1f528d"

# fd is `fdfind` on Debian/Ubuntu. Respect .gitignore, include dotfiles, skip .git.
_fzf_fd=$(whence -p fd || whence -p fdfind)   # whence -p: binary path, never an alias
if [[ -n $_fzf_fd ]]; then
  export FZF_DEFAULT_COMMAND="$_fzf_fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$_fzf_fd --hidden --follow --exclude .git"
  export FZF_ALT_C_COMMAND="$_fzf_fd --type d --hidden --follow --exclude .git"
fi

# Previews: bat (batcat) for files, eza tree for dirs; POSIX fallbacks.
_fzf_bat=$(whence -p bat || whence -p batcat)
_fzf_file_preview=${_fzf_bat:+$_fzf_bat --style=numbers --color=always --line-range=:300 {}}
: ${_fzf_file_preview:=head -300 {}}
if command -v eza >/dev/null 2>&1; then
  _fzf_dir_preview='eza --tree --level=2 --color=always {}'
else
  _fzf_dir_preview='ls -1 {}'
fi
export FZF_CTRL_T_OPTS="--preview '[ -d {} ] && $_fzf_dir_preview || $_fzf_file_preview' --preview-window=right:60%:wrap --bind 'ctrl-/:toggle-preview'"
export FZF_ALT_C_OPTS="--preview '$_fzf_dir_preview' --preview-window=right:60%"
unset _fzf_fd _fzf_bat _fzf_file_preview _fzf_dir_preview
