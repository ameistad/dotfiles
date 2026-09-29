#!/usr/bin/env bash

set -e

echo "🚀 Installing dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to create symlinks
link_file() {
    local src="$1"
    local dest="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"

    # Remove existing symlink, back up anything else. Timestamped so an earlier backup
    # is never overwritten (or, for directories, nested inside).
    local backup="$dest.backup.$(date +%Y%m%d%H%M%S)"
    if [[ -L "$dest" ]]; then
        echo "🔗 Removing existing symlink: $dest"
        rm "$dest"
    elif [[ -f "$dest" ]]; then
        echo "📦 Backing up existing file: $dest -> $backup"
        mv "$dest" "$backup"
    elif [[ -d "$dest" ]]; then
        echo "📦 Backing up existing directory: $dest -> $backup"
        mv "$dest" "$backup"
    fi

    # Create symlink
    echo "🔗 Linking $src -> $dest"
    ln -s "$src" "$dest"
}

# Clean up leftovers from previous installs
echo "🧹 Cleaning up old files..."
# Symlinks into the dotfiles that no longer resolve (e.g. a file removed from root/)
for link in "$HOME"/.* "$HOME"/* "$HOME/.config"/*; do
    if [[ -L "$link" && ! -e "$link" && "$(readlink "$link")" == "$DOTFILES_DIR"/* ]]; then
        echo "🗑️  Removing broken symlink: $link"
        rm "$link"
    fi
done
# Completion caches, so new or removed completions are picked up
rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}"/zsh/zcompdump* "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Install zsh configuration
echo "Installing zsh configuration..."
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Install neovim configuration
echo "Installing neovim configuration..."
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Install the bat theme (bat is `batcat` on Debian/Ubuntu). Link only the theme file so a
# local ~/.config/bat/config keeps working, then rebuild bat's cache so it finds the theme.
bat_bin="$(command -v bat || command -v batcat || true)"
bat_config_dir="${bat_bin:+$("$bat_bin" --config-dir 2> /dev/null || true)}"
if [[ -n "$bat_config_dir" ]]; then
    echo "Installing bat theme..."
    link_file "$DOTFILES_DIR/bat/themes/etterglod.tmTheme" "$bat_config_dir/themes/etterglod.tmTheme"
    "$bat_bin" cache --build > /dev/null || echo "⚠️  bat cache --build failed, run it manually"
elif [[ -n "$bat_bin" ]]; then
    echo "⏭️  Skipping bat theme ($bat_bin has no --config-dir, too old)"
else
    echo "⏭️  Skipping bat theme (bat not installed)"
fi

# Terminal emulator configs only make sense on the desktop, not on Linux servers.
if [[ "$OSTYPE" == darwin* ]]; then
    # Install ghostty
    echo "Installing ghostty configuration..."
    link_file "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

    # Install wezterm configuration
    echo "Installing wezterm configuration..."
    link_file "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
else
    echo "⏭️  Skipping terminal emulator configs (not macOS)"
fi

# Install root configuration files
echo "Installing root configuration files..."
# Enable globbing for hidden files
shopt -s dotglob
for file in "$DOTFILES_DIR/root"/*; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        # Skip .localrc - handled separately
        if [[ "$filename" != ".localrc" ]]; then
            link_file "$file" "$HOME/$filename"
        fi
    fi
done
# Disable dotglob to restore default behavior
shopt -u dotglob

# Create .localrc template if it doesn't exist
echo "📝 Setting up local environment..."
if [[ ! -f "$HOME/.localrc" ]]; then
    echo "📝 Creating .localrc template..."
    cat > "$HOME/.localrc" << 'EOF'
# Local environment variables
[[ -d /opt/homebrew/bin ]] && export PATH="/opt/homebrew/bin:$PATH"
export PROJECTS_DIRECTORY="$HOME/Projects"

# Uncomment on development machines to enable LSP, formatters, completion, and parser installs.
# export NVIM_PROFILE=dev

# Add your private environment variables here
# export GITHUB_TOKEN="your_token_here"
EOF
    echo "✏️  Please edit ~/.localrc to set your environment variables"
else
    echo "⏭️  Skipping .localrc - file already exists"
fi

# Sync neovim plugins to the lockfile and remove plugins no longer in the config
if command -v nvim > /dev/null; then
    echo "🔌 Syncing neovim plugins..."
    nvim --headless "+Lazy! restore" "+Lazy! clean" +qa > /dev/null 2>&1 \
        || echo "⚠️  Neovim plugin sync failed, run :Lazy in neovim to check"
fi

echo "✅ Dotfiles setup complete!"
echo "📝 Neovim config installed to ~/.config/nvim"

# The installer can't replace its parent shell. Let the user reload it directly
# so installation doesn't leave an extra shell to exit before disconnecting SSH.
echo "🔄 To load the new config, run: exec zsh -l"
