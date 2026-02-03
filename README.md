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

### Worktrees

The `zsh/modules/worktrees` module provides helpers for running coding agents in isolated [git worktrees](https://git-scm.com/docs/git-worktree). Each worktree gives an agent its own working directory and branch so it can make changes without touching your main checkout.

#### Directory layout

Worktrees live in a `.worktrees/` directory next to (not inside) the repo:

```
~/Projects/
  my-repo/            # main checkout
  .worktrees/
    feature-a/        # worktree created with `git worktree add`
    feature-b/
```

#### Setting up a worktree

```sh
cd ~/Projects/my-repo
git worktree add ../. worktrees/feature-a -b feature-a
```

#### Functions

| Function | Description |
|---|---|
| `wt-agent <slug>` | `cd` into the worktree matching `<slug>`, load its env files, and start the agent |
| `wt-loadenv [dir]` | Source `.env`, `.env.local`, and `.env.<env>` files from the repo root and optionally from a worktree directory |

#### Environment variables

| Variable | Default | Description |
|---|---|---|
| `WT_AGENT_CMD` | `codex` | Command used to start the agent (e.g. `claude`, `claude --model sonnet`) |
| `WT_ENV` | falls back to `NODE_ENV` or `ENV` | Name of the environment, used to load `.env.<name>` files |

#### Env file load order

`wt-loadenv` sources files in this order (later files override earlier ones):

1. `<repo-root>/.env`
2. `<repo-root>/.env.local`
3. `<repo-root>/.env.<env>` (if `WT_ENV`/`NODE_ENV`/`ENV` is set)
4. `<worktree>/.env`
5. `<worktree>/.env.local`
6. `<worktree>/.env.<env>`

#### Example workflow

```sh
# Create a worktree for a new feature
cd ~/Projects/my-repo
git worktree add ../.worktrees/login-fix -b login-fix

# Launch an agent in that worktree
export WT_AGENT_CMD='claude'
wt-agent login-fix

# When done, clean up
git worktree remove ../.worktrees/login-fix
```

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
