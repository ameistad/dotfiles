# Dotfiles

Originally forked from the excellent [holman/dotfiles](https://github.com/holman/dotfiles)

## Install

Run the install script:

```sh
./install.sh
```

## How it works

### Zsh Configuration

The main file is `zsh/.zshrc`. This file runs every time a new shell is created. The script automatically loads:

- `*/path.zsh` - PATH modifications (loaded first)
- `*/completion.zsh` - Completion scripts (loaded last)
- `*/aliases.zsh` - Command aliases
- All other `*.zsh` files in modules
- Functions from the `functions/` directory

### Modules

You can organize configurations under `zsh/modules/`. For example, if you have Node.js specific aliases, create a directory `zsh/modules/node/` and add an `aliases.zsh` file there.

### Neovim Configuration

The neovim configuration is in `nvim/init.lua` and will be symlinked to `~/.config/nvim/`.

## Adding New Tools

To add configuration for a new tool:

1. Create a new directory in the root (e.g., `git/`, `tmux/`)
2. Add the configuration files
3. Update `install.sh` to create the appropriate symlinks
4. Update this README


## Requirements
fzf
ripgrep

__Language servers (LSP)__
gopls - go install golang.org/x/tools/gopls@latest
lua
