# Vi keymap, on purpose. The shell was already landing in viins because
# EDITOR=nvim; this makes it explicit and fixes the rough edges.
# Loads before modules/* (glob order), so fzf's bindings land after `bindkey -v`.
bindkey -v
export KEYTIMEOUT=10   # 100ms: Esc feels instant, but Alt-<x> / arrow sequences
                       # still survive ssh latency (1 = 10ms is too tight remotely)

# ---- viins: keep the emacs keys your fingers already know ----
bindkey -M viins '^A'    beginning-of-line
bindkey -M viins '^E'    end-of-line
bindkey -M viins '^W'    backward-kill-word
bindkey -M viins '^U'    backward-kill-line
bindkey -M viins '^K'    kill-line
bindkey -M viins '^Y'    yank
bindkey -M viins '^?'    backward-delete-char   # backspace past the insert point
bindkey -M viins '^H'    backward-delete-char
bindkey -M viins '^[[3~' delete-char            # Delete
bindkey -M viins '^[[H'  beginning-of-line      # Home
bindkey -M viins '^[[F'  end-of-line            # End

# ---- history: prefix-aware Up/Down, ^P/^N, and k/j in vicmd ----
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for _m in viins vicmd; do
  bindkey -M $_m '^[[A' up-line-or-beginning-search
  bindkey -M $_m '^[OA' up-line-or-beginning-search
  bindkey -M $_m '^[[B' down-line-or-beginning-search
  bindkey -M $_m '^[OB' down-line-or-beginning-search
done
unset _m
bindkey -M viins '^P' up-line-or-beginning-search
bindkey -M viins '^N' down-line-or-beginning-search
bindkey -M vicmd 'k'  up-line-or-beginning-search
bindkey -M vicmd 'j'  down-line-or-beginning-search

# ---- vicmd: `v` edits the line in $EDITOR (default was visual-mode) ----
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# ---- cursor shape follows the keymap (DECSCUSR: beam in insert, block in normal) ----
# This file owns the cursor; prompt.zsh no longer touches it. The Linux console ignores it.
_cursor_beam()  { print -n '\e[5 q' }
_cursor_block() { print -n '\e[1 q' }
zle-keymap-select() { [[ $KEYMAP == vicmd ]] && _cursor_block || _cursor_beam }
zle-line-init()     { _cursor_beam }   # every new line starts in viins
zle-line-finish()   { _cursor_beam }   # don't hand a block cursor to the next program
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish
