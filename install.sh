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

# A script can't reload the shell that ran it, so replace this process with a fresh zsh.
# Exiting that zsh drops back to the old shell, so open a new terminal if you want it gone.
if [[ -t 0 && -t 1 ]] && command -v zsh > /dev/null; then
    echo "🔄 Starting a fresh zsh with the new config..."
    exec zsh -l
else
    echo "🔄 Please restart your terminal or run: exec zsh"
fi
