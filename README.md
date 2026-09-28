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

1. `*/path.zsh` - PATH modifications
2. All other `*.zsh` files under `config/` and `modules/` (aliases, exports, key bindings, prompt)
3. `*/completion.zsh` - Completion setup and completion files (loaded last, just before `compinit`)
4. Functions from the `functions/` directory (autoloaded)

Every tool-specific module is guarded with `command -v`, so the config loads cleanly on
machines that lack the tool. The same tree is used on macOS and Linux servers; OS
differences are handled inside the modules, not by separate installs.

### Shell behaviour

- **Vi keymap**, on purpose. `Esc` enters normal mode (block cursor), `i` returns to insert
  (beam cursor). `Ctrl-A/E/W/U/K/Y` still work in insert mode, `v` in normal mode edits the
  line in `$EDITOR`, and Up/Down search history by prefix. See `zsh/config/keybindings.zsh`.
- **fzf**: `Ctrl-R` history, `Ctrl-T` file/dir picker with bat/eza previews, `Alt-C` cd into a
  directory. On macOS, if `Alt-C` types `ç` in Ghostty, set `macos-option-as-alt = true`.
- **eza / bat**: `ls`, `ll`, `la`, `lt` use eza when installed; `cat` is bat with plain style
  (use `command cat` for the real one); `man` pages render through bat.
- **History** is shared between sessions, deduplicated, and 50k entries deep.
- Completion dumps and caches live in `~/.cache/zsh/`. After adding a new completion file,
  run `rm ~/.cache/zsh/zcompdump*` once so it gets picked up.
- `fzf --zsh` and `zoxide init zsh` output is cached in `~/.cache/zsh/init-*.zsh` and
  regenerated when the binary changes (see `zsh/config/init-cache.zsh`). Delete the file to
  force a refresh, for example after changing `_ZO_*` settings.

### Modules

You can organize configurations under `zsh/modules/`. For example, if you have Node.js specific aliases, create a directory `zsh/modules/node/` and add an `aliases.zsh` file there.

### Directory navigation

`p [directory/path]` jumps relative to `${PROJECTS_DIRECTORY:-$HOME/Projects}`;
`h [directory/path]` jumps relative to `$HOME`. With no argument, each jumps to
its base directory. Both share directory-only tab completion, `-h`/`--help`, and
errors that suggest the nearest existing parent when a nested path is missing.
Quote paths containing spaces, for example `p 'my project/src'`.

Set `PROJECTS_DIRECTORY` in `~/.localrc` to use a different projects directory.

### Worktrees

The `zsh/modules/worktrees` module provides helpers for running coding agents in isolated [git worktrees](https://git-scm.com/docs/git-worktree). Each worktree gives an agent its own working directory and branch so it can make changes without touching your main checkout.

#### Directory layout

Worktrees live in a `.worktrees/` directory inside the repo root (`wt-agent` adds it to
`.gitignore` the first time it creates one):

```
~/Projects/my-repo/     # main checkout
  .worktrees/
    feature-a/          # worktree created with `git worktree add`
    feature-b/
```

#### Setting up a worktree

```sh
cd ~/Projects/my-repo
git worktree add .worktrees/feature-a -b feature-a
```

#### Functions

| Function | Description |
|---|---|
| `wt-init` | Prompt for the agent command and persist it as `WT_AGENT_CMD` in the repo's `.env` |
| `wt-ls` | List worktrees and their branches |
| `wt-agent <slug>` | Create the worktree if missing, `cd` into it, load its env files, and start the agent |
| `wt-loadenv [dir]` | Source `.env`, `.env.local`, and `.env.<env>` files from the repo root and optionally from a worktree directory |
| `wt-merge <slug>` | Commit the worktree, merge it into the current branch, and clean up |
| `wt-rm [--force] <slug>` | Remove a worktree; refuses if it has uncommitted changes unless `--force` |

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
git worktree add .worktrees/login-fix -b login-fix

# Launch an agent in that worktree
export WT_AGENT_CMD='claude'
wt-agent login-fix

# When done, clean up
git worktree remove .worktrees/login-fix
```

### Neovim Configuration

The neovim configuration is in `nvim/init.lua` and will be symlinked to `~/.config/nvim/`.

The config supports two profiles through `NVIM_PROFILE`:

| Profile | How to enable | Intended use | Enabled |
|---|---|---|---|
| `lite` | default when `NVIM_PROFILE` is unset | Servers and config-file editing | Shared options, keymaps, theme, statusline, file picker, file browser, and basic UI plugins |
| `dev` | `export NVIM_PROFILE=dev` | Development machines | Everything in `lite`, plus LSP, Mason-managed tools, formatters, completion/snippets, MDX support, and Treesitter parser installation |

On development machines, enable the full development profile in `~/.localrc`:

```sh
export NVIM_PROFILE=dev
```

For a one-off launch without changing your shell profile:

```sh
NVIM_PROFILE=dev nvim
NVIM_PROFILE=lite nvim
```

Formatting (dev profile) runs on save. JS/TS/HTML/CSS use biome when the project has a
`biome.json`/`biome.jsonc`, otherwise prettierd (falling back to prettier), never both.
`<leader>f` formats the buffer, `<leader>cp` forces prettierd.

## Adding New Tools

To add configuration for a new tool:

1. Create a new directory in the root (e.g., `git/`, `tmux/`)
2. Add the configuration files
3. Update `install.sh` to create the appropriate symlinks
4. Update this README


## Requirements

Only `zsh` and `git` are required. Everything else is optional and detected at runtime
(Debian/Ubuntu package names in parentheses):

- `fzf` (0.48 or newer for `fzf --zsh`; older apt versions fall back to the distro's
  `/usr/share/doc/fzf/examples` scripts)
- `fd` (`fd-find`, binary `fdfind`)
- `bat` (binary `batcat` on Debian/Ubuntu)
- `eza`
- `ripgrep` (used by Neovim's picker)
- `zoxide`, `lazygit`, `gh`
- A Nerd Font on the desktop machine for Neovim and the terminal configs

### Current tool versions on Linux servers

The apt versions of `fzf` on older LTS releases are below 0.48. To get a current build,
download the release tarball for your architecture from
https://github.com/junegunn/fzf/releases and put the single `fzf` binary in `~/.local/bin`,
which is already on `PATH`. The same works for `fd`, `bat` and `eza`.

For `NVIM_PROFILE=dev`, Neovim uses Mason to install the configured language servers,
formatters, and related tools from `nvim/lua/plugins/lsp.lua`.
